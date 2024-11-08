import db from "../config/mysql.js";

export const getDonor = (req, res) => {
  const sql = "call ReadAllStock()";
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
};

export const createDonor = (req, res) => {
  const sql = "call create_donor(?, ?, ?, ?)"; // Adjust SQL to match your stored procedure
  const { donation_date, amount_id, person_id, facilitator_id } = req.body;

  if (!donation_date || !amount_id || !person_id || !facilitator_id) {
    return res.status(400).json({ error: "All fields are required" });
  }

  db.query(
    sql,
    [donation_date, amount_id, person_id, facilitator_id],
    (err, result) => {
      if (err) {
        console.error(err); // Log the error for debugging
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Donor created successfully" });
    }
  );
};
