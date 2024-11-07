import express from "express";
import db from "../config/mysql.js";
import { getDonor } from "../controller/donor.js";

const router = express.Router();

router.get("/", getDonor);

router.route("/:id").get((req, res) => {
  const sql = "call ReadDonor(?)";
  db.query(sql, [req.params.id], (err, result) => {
    if (err) throw err;
    if (result.length === 0) {
      return res.status(404).json({ message: "Donor not found" });
    }
    res.json(result[0]);
  });
});

export default router;
