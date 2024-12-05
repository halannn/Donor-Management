import express from "express";
import {
  createTransfusion,
  deleteTransfusion,
  readTransfusion,
  updateTransfusion,
} from "../controller/transfusion.js";
import { verifyUser, verifyAdmin } from "../middleware/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router
  .route("/")
  .get(verifyUser, readTransfusion)
  .post(verifyAdmin, createTransfusion);
router
  .route("/:id")
  .get(verifyUser, readTransfusion)
  .put(verifyAdmin, updateTransfusion)
  .delete(verifyAdmin, deleteTransfusion);

export default router;
