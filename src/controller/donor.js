import db from "../config/mysql.js";

export const getDonor = (req, res) => {
  const sql = "call ReadDonor()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results[0]);
  });
};

export const getDonorById = (req, res) => {
  const sql = "call ReadDonorById(?)";
  const { id } = req.params;
  if (!id) {
    return res.status(400).json({ error: "Donor ID is required" });
  }
  db.query(sql, [id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results[0].length === 0) {
      return res.status(404).json({ error: "Donor not found" });
    }
    res.json(results[0][0]);
  });
};

export const getSumDonor = (req, res) => {
  const sql = "SELECT SumDonor()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results[0]);
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
        console.error(err); // Log the error for debugging
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
  if (!id) {
    return res.status(400).json({ error: "Donor ID is required" });
  }
  if (!donation_date || !amount_id || !person_id || !facilitator_id) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [id, donation_date, amount_id, person_id, facilitator_id],
    (err, result) => {
      if (err) {
        console.error(err); // Log the error for debugging
        return res.status(500).json({ error: "Database error" });
      }
      console.log(result);
      res.json({ message: "Donor updated successfully" });
    }
  );
};

export const deleteDonor = (req, res) => {
  const sql = "call DeleteDonor(?)";
  const { id } = req.params;
  if (!id) {
    return res.status(400).json({ error: "Donor ID is required" });
  }
  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error(err); // Log the error for debugging
      return res.status(500).json({ error: "Database error" });
    }
    console.log(result);
    res.json({ message: "Donor deleted successfully" });
  });
};
