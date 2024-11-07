import db from "../config/mysql.js";

export const getDonor = (req, res) => {
  const sql = "SELECT * FROM donor";
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
};

export const getDonorById = (req, res) => {
  const sql = "SELECT * FROM donor WHERE donor_id = ?";
  db.query(sql, [req.params.id], (err, result) => {
    if (err) throw err;
    if (result.length === 0) {
      return res.status(404).json({ message: "Donor not found" });
    }
    res.json(result[0]);
  });
};