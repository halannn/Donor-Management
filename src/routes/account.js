import express from "express";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

export default router;