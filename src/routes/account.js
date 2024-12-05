import express from "express";
import {
  createAccount,
  deleteAccount,
  readAccount,
  updateAccount,
} from "../controller/account.js";
import { verifyAdmin } from "../middleware/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router
  .route("/")
  .get(verifyAdmin, readAccount)
  .post(verifyAdmin, createAccount);

router
  .route("/:id")
  .get(verifyAdmin, readAccount)
  .put(verifyAdmin, updateAccount)
  .delete(verifyAdmin, deleteAccount);

export default router;
