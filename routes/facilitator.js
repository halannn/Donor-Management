const express = require("express");
const router = express.Router();
const mysql = require("mysql");
require("dotenv").config(); // Load environment variables from .env file

// Database connection
var db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

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

module.exports = router;
