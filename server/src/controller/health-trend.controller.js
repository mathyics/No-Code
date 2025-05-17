import { asyncHandler } from "../Utils/_03_asyncHandler.utils.js";
import { ApiError } from "../Utils/_04_Api_Error.utils.js";
import { ApiResponse } from "../Utils/_05_Api_Response.utils.js";
import { HealthTrend } from "../models/health-trend.model.js";
import { Symptom } from "../models/symptom.model.js";
import OpenAI from "openai";
import { 
    OPENAI_CONFIG,
    HEALTH_ANALYSIS
} from "../config/constants.js";

const openai = new OpenAI({
    apiKey: OPENAI_CONFIG.API_KEY
});

// Generate health insights using OpenAI
const generateHealthInsights = async (symptoms) => {
    const symptomsData = symptoms.map(s => ({
        description: s.textDescription,
        severity: s.aiAnalysis.severity,
        conditions: s.aiAnalysis.possibleConditions,
        date: s.createdAt
    }));

    const completion = await openai.chat.completions.create({
        model: OPENAI_CONFIG.MODELS.GPT,
        messages: [
            {
                role: "system",
                content: `You are a medical AI assistant analyzing long-term health trends.
                         Analyze the provided symptom history and identify:
                         1. Patterns in symptom occurrence
                         2. Potential risk factors
                         3. Lifestyle recommendations
                         4. Whether any conditions appear to be chronic or recurring
                         Format response as JSON with fields: patterns, riskFactors, recommendations, chronicConditions`
            },
            {
                role: "user",
                content: JSON.stringify(symptomsData)
            }
        ]
    });

    return JSON.parse(completion.choices[0].message.content);
};

// Generate or update health trend analysis
const generateTrendAnalysis = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
        throw new ApiError(400, "Start date and end date are required");
    }

    // Get symptoms for the specified period
    const symptoms = await Symptom.find({
        user: userId,
        createdAt: {
            $gte: new Date(startDate),
            $lte: new Date(endDate)
        }
    }).sort({ createdAt: 1 });

    if (symptoms.length === 0) {
        throw new ApiError(404, "No symptoms found for the specified period");
    }

    // Generate AI insights
    const insights = await generateHealthInsights(symptoms);

    // Create or update health trend
    const healthTrend = await HealthTrend.findOneAndUpdate(
        {
            user: userId,
            "period.startDate": new Date(startDate),
            "period.endDate": new Date(endDate)
        },
        {
            user: userId,
            period: {
                startDate: new Date(startDate),
                endDate: new Date(endDate)
            },
            symptoms: symptoms.map(s => s._id),
            analysis: {
                commonConditions: insights.patterns.map(p => ({
                    condition: p.condition,
                    frequency: p.frequency,
                    severity: p.severity
                })),
                recommendations: insights.recommendations,
                riskFactors: insights.riskFactors.map(r => ({
                    factor: r.factor,
                    level: r.level
                }))
            },
            metadata: {
                totalEntries: symptoms.length,
                mostFrequentSymptoms: insights.patterns
                    .sort((a, b) => b.frequency - a.frequency)
                    .slice(0, 5)
                    .map(p => p.condition)
            }
        },
        {
            new: true,
            upsert: true
        }
    );

    // Calculate metrics
    await healthTrend.calculateMetrics();

    return res
        .status(200)
        .json(
            new ApiResponse(
                200,
                healthTrend,
                "Health trend analysis generated successfully"
            )
        );
});

// Get user's health trends
const getUserHealthTrends = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const { period = HEALTH_ANALYSIS.TIME_PERIODS.MONTH } = req.query;

    const endDate = new Date();
    const startDate = new Date();

    switch (period) {
        case HEALTH_ANALYSIS.TIME_PERIODS.WEEK:
            startDate.setDate(startDate.getDate() - 7);
            break;
        case HEALTH_ANALYSIS.TIME_PERIODS.MONTH:
            startDate.setMonth(startDate.getMonth() - 1);
            break;
        case HEALTH_ANALYSIS.TIME_PERIODS.YEAR:
            startDate.setFullYear(startDate.getFullYear() - 1);
            break;
        default:
            startDate.setMonth(startDate.getMonth() - 1); // Default to last month
    }

    const healthTrends = await HealthTrend.find({
        user: userId,
        "period.startDate": { $gte: startDate },
        "period.endDate": { $lte: endDate }
    }).sort({ "period.startDate": -1 });

    return res
        .status(200)
        .json(
            new ApiResponse(
                200,
                healthTrends,
                "Health trends retrieved successfully"
            )
        );
});

export {
    generateTrendAnalysis,
    getUserHealthTrends
}; 