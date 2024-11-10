import express from "express";
import {
  createAccount,
  deleteAccount,
  readAccount,
  updateAccount,
} from "../controller/account.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(readAccount).post(createAccount);

router.route("/:id").get(readAccount).put(updateAccount).delete(deleteAccount);

export default router;
