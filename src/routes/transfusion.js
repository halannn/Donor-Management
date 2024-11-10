import express from "express";
import {
  createTransfusion,
  deleteTransfusion,
  readTransfusion,
  updateTransfusion,
} from "../controller/transfusion.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(readTransfusion).post(createTransfusion);
router
  .route("/:id")
  .get(readTransfusion)
  .put(updateTransfusion)
  .delete(deleteTransfusion);

export default router;
