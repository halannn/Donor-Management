import express from "express";
import { createDonor, getDonor } from "../controller/donor.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(getDonor).post(createDonor);

// router.route("/:id").get(getDonorById);

export default router;
