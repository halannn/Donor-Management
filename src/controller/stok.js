import db from "../config/mysql.js";

export const readStock = (req, res) => {
  const sql = "call ReadStock(?)";
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

export const createStok = (req, res) => {
  const sql = "call CreateStock(?, ?, ?)";
  const { blood_type, volume_ml, facilitator_id } = req.body;
  if (!blood_type || !volume_ml || !facilitator_id) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(sql, [blood_type, volume_ml, facilitator_id], (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Stock created successfully" });
  });
};

export const updateStock = (req, res) => {
  const sql = "call UpdateStock(?, ?, ?)";
  const { id } = req.params;
  const { blood_type, volume_ml } = req.body;
  if (isNaN(id)) {
    return res.status(400).json({ error: "Params must be a number" });
  }
  if (!blood_type || !volume_ml) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(sql, [id, blood_type, volume_ml], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(200).json({ message: "Stock updated successfully" });
  });
};

export const deleteStock = (req, res) => {
  const sql = "call DeleteStock(?)";
  const { id } = req.params;
  db.query(sql, [id], (err) => {
    if (err) {
      console.error(err);
      return res.status(400).json({ message: "Params must be a number" });
    }
    res.status(200).json({ message: "Stock deleted successfully" });
  });
};
