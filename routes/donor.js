const express = require("express");
const router = express.Router();
const mysql = require("mysql");
require('dotenv').config(); // Load environment variables from .env file

// Database connection
var db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

router.get("/", (req, res) => {
  const sql = "SELECT * FROM Donor";
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

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

module.exports = router;