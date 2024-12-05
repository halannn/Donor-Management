import express from "express";
import {
  createDonor,
  deleteDonor,
  readDonor,
  updateDonor,
} from "../controller/donor.js";
import { verifyUser, verifyAdmin } from "../middleware/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(verifyUser, readDonor).post(verifyAdmin, createDonor);

router
  .route("/:id")
  .get(verifyUser, readDonor)
  .put(verifyAdmin, updateDonor)
  .delete(verifyAdmin, deleteDonor);

export default router;
