import { Router } from "express";
import {
    submitSymptoms,
    getUserSymptomHistory,
    getSymptomProgression
} from "../controller/symptom.controller.js";
import { verifyJWT } from "../middlewares/_02_auth.middleware.js";
import { upload } from "../middlewares/_01_multer.middleware.js";

const router = Router();

// Apply JWT verification to all routes
router.use(verifyJWT);

// Configure multer for both voice and image uploads
const uploadFields = upload.fields([
    { name: 'voice', maxCount: 1 },
    { name: 'images', maxCount: 5 }
]);

// Route to submit symptoms with voice and image upload
router.post("/submit", uploadFields, submitSymptoms);

// Route to get user's symptom history
router.get("/history", getUserSymptomHistory);

// Route to get symptom progression analysis
router.get("/progression", getSymptomProgression);

export default router; 