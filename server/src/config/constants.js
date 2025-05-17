import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Server Configuration
export const SERVER_CONFIG = {
    PORT: process.env.PORT || 8000,
    CORS_ORIGIN: process.env.CORS_ORIGIN || "http://localhost:3000"
};

// MongoDB Configuration
export const DB_CONFIG = {
    MONGODB_URI: process.env.MONGODB_URI || "mongodb://localhost:27017/mediscan"
};

// JWT Configuration
export const JWT_CONFIG = {
    ACCESS_TOKEN_SECRET: process.env.ACCESS_TOKEN_SECRET,
    ACCESS_TOKEN_EXPIRY: process.env.ACCESS_TOKEN_EXPIRY || "1d",
    REFRESH_TOKEN_SECRET: process.env.REFRESH_TOKEN_SECRET,
    REFRESH_TOKEN_EXPIRY: process.env.REFRESH_TOKEN_EXPIRY || "10d"
};

// OpenAI Configuration
export const OPENAI_CONFIG = {
    API_KEY: process.env.OPENAI_API_KEY,
    MODELS: {
        GPT: "gpt-3.5-turbo",
        WHISPER: "whisper-1"
    }
};

// HuggingFace Configuration
export const HUGGINGFACE_CONFIG = {
    API_KEY: process.env.HUGGINGFACE_API_KEY,
    MODELS: {
        GENERAL_MEDICAL: "microsoft/resnet-50",
        SKIN_CONDITION: "google/vit-base-patch16-224",
        MEDICAL_SEGMENTATION: "nvidia/med-seg"
    }
};

// Cloudinary Configuration
export const CLOUDINARY_CONFIG = {
    CLOUD_NAME: process.env.CLOUDINARY_CLOUD_NAME,
    API_KEY: process.env.CLOUDINARY_API_KEY,
    API_SECRET: process.env.CLOUDINARY_API_SECRET
};

// Validation Constants
export const VALIDATION = {
    MAX_IMAGE_SIZE: 5 * 1024 * 1024, // 5MB
    ALLOWED_IMAGE_TYPES: ["image/jpeg", "image/png", "image/webp"],
    MAX_VOICE_SIZE: 10 * 1024 * 1024, // 10MB
    ALLOWED_VOICE_TYPES: ["audio/wav", "audio/mpeg", "audio/webm"],
    MAX_IMAGES_PER_REQUEST: 5
};

// Health Analysis Constants
export const HEALTH_ANALYSIS = {
    SEVERITY_LEVELS: {
        LOW: "LOW",
        MEDIUM: "MEDIUM",
        HIGH: "HIGH",
        EMERGENCY: "EMERGENCY"
    },
    RISK_LEVELS: {
        LOW: "LOW",
        MEDIUM: "MEDIUM",
        HIGH: "HIGH"
    },
    TIME_PERIODS: {
        WEEK: "week",
        MONTH: "month",
        YEAR: "year"
    }
}; 