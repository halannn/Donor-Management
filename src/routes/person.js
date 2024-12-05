import express from "express";
import {
  createPerson,
  deletePerson,
  readPerson,
  updatePerson,
} from "../controller/person.js";
import { verifyUser, verifyAdmin } from "../middleware/auth.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(verifyUser, readPerson).post(verifyAdmin, createPerson);
router
  .route("/:id")
  .get(verifyUser, readPerson)
  .put(verifyAdmin, updatePerson)
  .delete(verifyAdmin, deletePerson);

export default router;
