import express from "express";
import {
  createDonor,
  deleteDonor,
  getDonor,
  getDonorById,
  getSumDonor,
  updateDonor,
} from "../controller/donor.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(getDonor).post(createDonor);

router.route("/sum").get(getSumDonor);

router.route("/:id").get(getDonorById).put(updateDonor).delete(deleteDonor);

export default router;
