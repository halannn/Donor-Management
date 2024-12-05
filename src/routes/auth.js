import express from "express";
import { loginAccount, createAccount } from "../controller/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/login").post(loginAccount);

router.route("/register").post(createAccount);

export default router;
