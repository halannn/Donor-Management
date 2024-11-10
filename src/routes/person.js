import express from "express";
import {
  createPerson,
  deletePerson,
  readPerson,
  updatePerson,
} from "../controller/person.js";

const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(readPerson).post(createPerson);
// router.route("/sum").get();
router.route("/:id").get(readPerson).put(updatePerson).delete(deletePerson);

export default router;
