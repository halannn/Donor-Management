import db from "../config/mysql.js";

export const getTransfusion = (req, res) => {
  const sql = "call ReadTransfusion()";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Transfusion not found" });
    }
    res.json(result[0]);
  });
};

export const getTransfusionById = (req, res) => {
  const sql = "call ReadTransfusionById(?)";
  if (!req.params.id) {
    return res.status(400).json({ error: "Transfusion ID is required" });
  }
  db.query(sql, req.params.id, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Transfusion not found" });
    }
    res.json(result[0]);
  });
};

export const getSumTransfusion = (req, res) => {
  const sql = "SELECT SumTransfusion()";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(result[0]);
  });
};

export const createTransfusion = (req, res) => {
  const sql = "call CreateTransfusion(?, ?, ?, ?, ?)";
  const { transfusion_date, volume_ml, donor_id, facilitator_id, person_id } =
    req.body;
  if (
    !transfusion_date ||
    !volume_ml ||
    !donor_id ||
    !facilitator_id ||
    !person_id
  ) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [transfusion_date, volume_ml, person_id, facilitator_id, person_id],
    (err) => {
      if (err) {
        console.error(err); // Log the error for debugging
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Transfusion created successfully" });
    }
  );
};

export const updateTransfusion = (req, res) => {
  const sql = "call UpdateTransfusion(?, ?, ?, ?, ?, ?)";
  const { id } = req.params;
  const { transfusion_date, volume_ml, donor_id, facilitator_id, person_id } =
    req.body;
  if (!id) {
    return res.status(400).json({ error: "Transfusion ID is required" });
  }
  if (
    !transfusion_date ||
    !volume_ml ||
    !donor_id ||
    !facilitator_id ||
    !person_id
  ) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [id, transfusion_date, volume_ml, donor_id, facilitator_id, person_id],
    (err) => {
      if (err) {
        console.error(err); // Log the error for debugging
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Transfusion updated successfully" });
    }
  );
};

export const deleteTransfusion = (req, res) => {
  const sql = "call DeleteTransfusion(?)";
  const { id } = req.params;
  if (!id) {
    return res.status(400).json({ error: "Transfusion ID is required" });
  }
  db.query(sql, [id], (err) => {
    if (err) {
      console.error(err); // Log the error for debugging
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Transfusion deleted successfully" });
  });
};
