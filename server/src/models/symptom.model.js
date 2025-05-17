import mongoose from "mongoose";

const symptomSchema = new mongoose.Schema(
    {
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true
        },
        textDescription: {
            type: String,
            required: true
        },
        voiceTranscription: {
            type: String,
            default: null
        },
        images: [{
            url: {
                type: String,
                required: true
            },
            analysis: {
                type: mongoose.Schema.Types.Mixed,
                default: null
            }
        }],
        aiAnalysis: {
            possibleConditions: [{
                condition: String,
                confidence: Number
            }],
            severity: {
                type: String,
                enum: ["LOW", "MEDIUM", "HIGH", "EMERGENCY"],
                required: true
            },
            recommendation: {
                type: String,
                required: true
            }
        },
        status: {
            type: String,
            enum: ["PENDING", "ANALYZED", "ARCHIVED"],
            default: "PENDING"
        }
    },
    {
        timestamps: true
    }
);

export const Symptom = mongoose.model("Symptom", symptomSchema); 