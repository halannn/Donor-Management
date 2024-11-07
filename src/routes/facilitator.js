import express from "express";
import db from "../config/mysql.js";

const router = express.Router();

// Middleware to parse JSON bodies
router.use(express.json());

// Create new Facilitator
router
  .route("/")
  // Get all Facilitators
  .get((req, res) => {
    const sql = "SELECT * FROM Facilitator";
    db.query(sql, (err, results) => {
      if (err) return res.status(500);
      res.json(results);
    });
  });
// Add new Facilitator

router
  .route("/:id")
  // Get Facilitator by ID
  .get((req, res) => {
    const sql = "SELECT * FROM Facilitator WHERE Facilitator_id = ?";
    db.query(sql, [req.params.id], (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.length === 0) {
        return res.status(404).json({ message: "Facilitator not found" });
      }
      res.json(result[0]);
    });
  });
// Update Facilitator by ID

// Delete Facilitator by ID

// Get Facilitator by Name (using query parameter)
router.get("/search/name", (req, res) => {
  const { name } = req.query;
  const sql = "SELECT * FROM Facilitator WHERE facilitator_name = ?";
  db.query(sql, [name], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

export default router;
