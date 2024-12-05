import express from "express";
import {
  createStok,
  deleteStock,
  readStock,
  updateStock,
} from "../controller/stok.js";
import { verifyUser, verifyAdmin } from "../middleware/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(verifyUser, readStock).post(verifyAdmin, createStok);
router
  .route("/:id")
  .get(verifyUser, readStock)
  .put(verifyAdmin, updateStock)
  .delete(verifyAdmin, deleteStock);

export default router;
