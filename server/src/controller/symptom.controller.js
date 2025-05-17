import { asyncHandler } from "../Utils/_03_asyncHandler.utils.js";
import { ApiError } from "../Utils/_04_Api_Error.utils.js";
import { ApiResponse } from "../Utils/_05_Api_Response.utils.js";
import { uploadOnCloudinary } from "../Utils/_06_cloudinary.file_uploading.util.js";
import { Symptom } from "../models/symptom.model.js";
import OpenAI from "openai";
import { HfInference } from "@huggingface/inference";
import fs from "fs/promises";
import { 
    OPENAI_CONFIG, 
    HUGGINGFACE_CONFIG,
    HEALTH_ANALYSIS
} from "../config/constants.js";

const openai = new OpenAI({
    apiKey: OPENAI_CONFIG.API_KEY
});

const hf = new HfInference(HUGGINGFACE_CONFIG.API_KEY);

// Function to transcribe voice using OpenAI Whisper
const transcribeVoice = async (audioPath) => {
    try {
        const transcription = await openai.audio.transcriptions.create({
            file: await fs.readFile(audioPath),
            model: OPENAI_CONFIG.MODELS.WHISPER,
            language: "en",
        });
        return transcription.text;
    } catch (error) {
        console.error("Voice transcription error:", error);
        return null;
    }
};

// Function to analyze text symptoms using OpenAI with enhanced medical context
const analyzeTextSymptoms = async (textDescription, userHistory = null) => {
    let systemPrompt = "You are a medical AI assistant specialized in early symptom analysis. ";
    systemPrompt += "Analyze the symptoms and provide possible conditions, severity level (LOW/MEDIUM/HIGH/EMERGENCY), and recommendations. ";
    systemPrompt += "Consider these guidelines:\n";
    systemPrompt += "- Focus on early detection and prevention\n";
    systemPrompt += "- Always err on the side of caution\n";
    systemPrompt += "- Consider common conditions first\n";
    systemPrompt += "- Flag any emergency symptoms immediately\n";
    
    if (userHistory) {
        systemPrompt += "\nPatient history:\n" + JSON.stringify(userHistory);
    }

    const completion = await openai.chat.completions.create({
        model: OPENAI_CONFIG.MODELS.GPT,
        messages: [
            {
                role: "system",
                content: systemPrompt
            },
            {
                role: "user",
                content: textDescription
            }
        ]
    });

    return JSON.parse(completion.choices[0].message.content);
};

// Function to analyze medical images using specialized HuggingFace models
const analyzeImage = async (imageUrl) => {
    try {
        const results = await Promise.all([
            // General medical image classification
            hf.imageClassification({
                model: HUGGINGFACE_CONFIG.MODELS.GENERAL_MEDICAL,
                data: imageUrl
            }),
            // Skin condition analysis
            hf.imageClassification({
                model: HUGGINGFACE_CONFIG.MODELS.SKIN_CONDITION,
                data: imageUrl
            }),
            // Medical segmentation
            hf.imageClassification({
                model: HUGGINGFACE_CONFIG.MODELS.MEDICAL_SEGMENTATION,
                data: imageUrl
            })
        ]);

        return {
            general: results[0],
            skin: results[1],
            specialized: results[2],
            timestamp: new Date()
        };
    } catch (error) {
        console.error("Image analysis error:", error);
        return null;
    }
};

const submitSymptoms = asyncHandler(async (req, res) => {
    const { textDescription } = req.body;
    const userId = req.user._id;

    if (!textDescription?.trim() && !req.files?.voice) {
        throw new ApiError(400, "Either symptom description or voice recording is required");
    }

    // Handle voice transcription if present
    let finalTextDescription = textDescription;
    if (req.files?.voice) {
        const transcription = await transcribeVoice(req.files.voice[0].path);
        if (transcription) {
            finalTextDescription = transcription;
        }
    }

    // Get user's recent history for context
    const recentHistory = await Symptom.find({ user: userId })
        .sort({ createdAt: -1 })
        .limit(3);

    // Handle image upload and analysis
    let imageAnalyses = [];
    if (req.files?.images) {
        for (const image of req.files.images) {
            const uploadedImage = await uploadOnCloudinary(image.path);
            if (uploadedImage) {
                const analysis = await analyzeImage(uploadedImage.url);
                imageAnalyses.push({
                    url: uploadedImage.url,
                    analysis
                });
            }
        }
    }

    // Analyze symptoms using OpenAI with historical context
    const aiAnalysis = await analyzeTextSymptoms(finalTextDescription, recentHistory);

    // Create symptom record
    const symptom = await Symptom.create({
        user: userId,
        textDescription: finalTextDescription,
        voiceTranscription: req.files?.voice ? finalTextDescription : null,
        images: imageAnalyses,
        aiAnalysis,
        status: "ANALYZED"
    });

    return res
        .status(201)
        .json(
            new ApiResponse(
                201,
                symptom,
                "Symptoms analyzed successfully"
            )
        );
});

const getUserSymptomHistory = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const symptoms = await Symptom.find({ user: userId })
        .sort({ createdAt: -1 })
        .skip((page - 1) * limit)
        .limit(limit);

    const total = await Symptom.countDocuments({ user: userId });

    return res
        .status(200)
        .json(
            new ApiResponse(
                200,
                {
                    symptoms,
                    pagination: {
                        page,
                        limit,
                        total,
                        pages: Math.ceil(total / limit)
                    }
                },
                "Symptom history retrieved successfully"
            )
        );
});

// Get detailed analysis of symptom progression over time
const getSymptomProgression = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const { startDate, endDate } = req.query;

    const query = {
        user: userId,
        createdAt: {}
    };

    if (startDate) {
        query.createdAt.$gte = new Date(startDate);
    }
    if (endDate) {
        query.createdAt.$lte = new Date(endDate);
    }

    const symptoms = await Symptom.find(query)
        .sort({ createdAt: 1 });

    // Analyze progression
    const progression = {
        totalEntries: symptoms.length,
        severityTrend: symptoms.map(s => ({
            date: s.createdAt,
            severity: s.aiAnalysis.severity
        })),
        commonConditions: {},
        timeline: symptoms.map(s => ({
            date: s.createdAt,
            conditions: s.aiAnalysis.possibleConditions,
            severity: s.aiAnalysis.severity
        }))
    };

    // Calculate common conditions
    symptoms.forEach(symptom => {
        symptom.aiAnalysis.possibleConditions.forEach(condition => {
            if (!progression.commonConditions[condition.condition]) {
                progression.commonConditions[condition.condition] = 0;
            }
            progression.commonConditions[condition.condition]++;
        });
    });

    return res
        .status(200)
        .json(
            new ApiResponse(
                200,
                progression,
                "Symptom progression analysis retrieved successfully"
            )
        );
});

export {
    submitSymptoms,
    getUserSymptomHistory,
    getSymptomProgression
}; 