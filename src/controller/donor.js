import db from "../config/mysql.js";

export const readDonor = (req, res) => {
  const sql = "call ReadDonor(?)";
  const { id } = req.params;
  db.query(sql, [id], (err, results) => {
    if (err) {
      return res.status(400).json({ message: "Params must be a number" });
    }
    if (results[0].length !== 1) {
      res.json(results[0]);
    } else {
      res.json(results[0][0]);
    }
  });
};

export const createDonor = (req, res) => {
  const sql = "call CreateDonor(?, ?, ?, ?)";
  const { donation_date, amount_id, person_id, facilitator_id } = req.body;
  if (!donation_date || !amount_id || !person_id || !facilitator_id) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [donation_date, amount_id, person_id, facilitator_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Donor created successfully" });
    }
  );
};

export const updateDonor = (req, res) => {
  const sql = "call UpdateDonor(?, ?, ?, ?, ?)";
  const { id } = req.params;
  const { donation_date, amount_id, person_id, facilitator_id } = req.body;
  if (isNaN(id)) {
    return res.status(400).json({ error: "Params must be a number" });
  }
  if (!donation_date || !amount_id || !person_id || !facilitator_id) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [id, donation_date, amount_id, person_id, facilitator_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(200).json({ message: "Donor updated successfully" });
    }
  );
};

export const deleteDonor = (req, res) => {
  const sql = "call DeleteDonor(?)";
  const { id } = req.params;
  db.query(sql, [id], (err) => {
    if (err) {
      return res.status(400).json({ message: "Params must be a number" });
    }
    res.json({ message: "Donor deleted successfully" });
  });
};
