import express from "express";
import {
  createTransfusion,
  deleteTransfusion,
  getSumTransfusion,
  getTransfusion,
  getTransfusionById,
  updateTransfusion,
} from "../controller/transfusion.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(getTransfusion).post(createTransfusion);
router.route("/sum").get(getSumTransfusion);
router
  .route("/:id")
  .get(getTransfusionById)
  .put(updateTransfusion)
  .delete(deleteTransfusion);

export default router;
