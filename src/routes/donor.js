import express from "express";
import {
  createDonor,
  deleteDonor,
  readDonor,
  updateDonor,
} from "../controller/donor.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(readDonor).post(createDonor);

router.route("/:id").get(readDonor).put(updateDonor).delete(deleteDonor);

export default router;
