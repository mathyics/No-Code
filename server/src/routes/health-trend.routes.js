import { Router } from "express";
import {
    generateTrendAnalysis,
    getUserHealthTrends
} from "../controller/health-trend.controller.js";
import { verifyJWT } from "../middlewares/_02_auth.middleware.js";

const router = Router();

// Apply JWT verification to all routes
router.use(verifyJWT);

// Route to generate/update health trend analysis
router.post("/analyze", generateTrendAnalysis);

// Route to get user's health trends
router.get("/trends", getUserHealthTrends);

export default router; 