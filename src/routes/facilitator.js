import express from "express";
import { getFacilitator, getFacilitatorById } from "../controller/facilitator.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

// Create new Facilitator
router
  .route("/")
  // Get all Facilitators
  .get(getFacilitator)

router
  .route("/:id")
  // Get Facilitator by ID
  .get(getFacilitatorById);

export default router;
