import express from "express";
import { getDonor, getDonorById } from "../controller/donor.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.get("/", getDonor);

router.route("/:id").get(getDonorById);

export default router;