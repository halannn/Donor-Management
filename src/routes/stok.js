import express from "express";
import {
  createStok,
  deleteStock,
  readStock,
  readStockById,
  readSumStock,
  updateStock,
} from "../controller/stok.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(readStock).post(createStok);
router.route("/sum").get(readSumStock);
router.route("/:id").get(readStockById).put(updateStock).delete(deleteStock);

export default router;
