import express from "express";
import {
  createStok,
  deleteStock,
  readStock,
  updateStock,
} from "../controller/stok.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(readStock).post(createStok);
router.route("/:id").get(readStock).put(updateStock).delete(deleteStock);

export default router;
