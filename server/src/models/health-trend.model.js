import mongoose from "mongoose";

const healthTrendSchema = new mongoose.Schema(
    {
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true
        },
        period: {
            startDate: {
                type: Date,
                required: true
            },
            endDate: {
                type: Date,
                required: true
            }
        },
        symptoms: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: "Symptom"
        }],
        analysis: {
            commonConditions: [{
                condition: String,
                frequency: Number,
                severity: String
            }],
            severityTrend: {
                type: Map,
                of: Number,
                default: {}
            },
            recommendations: [{
                type: String
            }],
            riskFactors: [{
                factor: String,
                level: {
                    type: String,
                    enum: ["LOW", "MEDIUM", "HIGH"]
                }
            }]
        },
        metadata: {
            totalEntries: Number,
            averageSeverity: String,
            mostFrequentSymptoms: [String],
            lastUpdated: Date
        }
    },
    {
        timestamps: true
    }
);

// Add index for efficient querying
healthTrendSchema.index({ user: 1, "period.startDate": 1, "period.endDate": 1 });

// Method to calculate trend metrics
healthTrendSchema.methods.calculateMetrics = async function() {
    const symptoms = await mongoose.model("Symptom").find({
        _id: { $in: this.symptoms }
    });

    // Calculate average severity
    const severityWeights = {
        LOW: 1,
        MEDIUM: 2,
        HIGH: 3,
        EMERGENCY: 4
    };

    const severitySum = symptoms.reduce((sum, symptom) => {
        return sum + severityWeights[symptom.aiAnalysis.severity];
    }, 0);

    this.metadata.averageSeverity = 
        severityWeights[Math.round(severitySum / symptoms.length)];

    // Update last updated timestamp
    this.metadata.lastUpdated = new Date();

    return this.save();
};

export const HealthTrend = mongoose.model("HealthTrend", healthTrendSchema); 