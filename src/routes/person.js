import express from 'express';
import { createPerson, deletePerson, getPerson, getPersonById, updatePerson } from '../controller/person.js';


const router = express.Router();
// Middleware to parse JSON bodies
router.use(express.json());

router.route("/").get(getPerson).post(createPerson);
// router.route("/sum").get();
router.route("/:id").get(getPersonById).put(updatePerson).delete(deletePerson);


export default router;
