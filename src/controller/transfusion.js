import db from "../config/mysql.js";

export const readTransfusion = (req, res) => {
  const sql = "call ReadTransfusion(?)";
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

export const createTransfusion = (req, res) => {
  const sql = "call CreateTransfusion(?, ?, ?, ?)";
  const { transfusion_date, volume_ml, facilitator_id, person_id } = req.body;
  if (!transfusion_date || !volume_ml || !facilitator_id || !person_id) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [transfusion_date, volume_ml, person_id, facilitator_id, person_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Transfusion created successfully" });
    }
  );
};

export const updateTransfusion = (req, res) => {
  const sql = "call UpdateTransfusion(?, ?, ?, ?, ?)";
  const { id } = req.params;
  const { transfusion_date, volume_ml, facilitator_id, person_id } = req.body;
  if (!id) {
    return res.status(400).json({ error: "Transfusion ID is required" });
  }
  if (!transfusion_date || !volume_ml || !facilitator_id || !person_id) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [id, transfusion_date, volume_ml, facilitator_id, person_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(200).json({ message: "Transfusion updated successfully" });
    }
  );
};

export const deleteTransfusion = (req, res) => {
  const sql = "call DeleteTransfusion(?)";
  const { id } = req.params;
  db.query(sql, [id], (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Transfusion deleted successfully" });
  });
};
