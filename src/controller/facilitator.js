import db from "../config/mysql.js";

export const getFacilitator = (req, res) => {
  const sql = "SELECT * FROM facilitator";
  db.query(sql, (err, results) => {
    if (err) return res.status(500);
    res.json(results);
  });
};

export const getFacilitatorById = (req, res) => {
  const sql = "SELECT * FROM facilitator WHERE facilitator_id = ?";
  db.query(sql, [req.params.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};