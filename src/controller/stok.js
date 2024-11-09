import db from "../config/mysql.js";

export const readStock = (req, res) => {
  const sql = "call ReadStock()";
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results[0]);
  });
};

export const readStockById = (req, res) => {
  const sql = "call ReadStockById(?)";
  db.query(sql, req.params.id, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json(results[0]);
  });
};

export const readSumStock = (req, res) => {
  const sql = "SELECT SumStock()";
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results[0]);
  });
};

export const createStok = (req, res) => {
  const sql = "call CreateStock(?, ?, ?)";
  const { blood_type, volume_ml, facilitator_id } = req.body;
  db.query(sql, [blood_type, volume_ml, facilitator_id], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Stock created successfully" });
  });
};

export const updateStock = (req, res) => {
  const sql = "call UpdateStock(?, ?, ?)";
  const { blood_type, volume_ml } = req.body;
  db.query(sql, [req.params.id, blood_type, volume_ml], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Stock updated successfully" });
  });
};

export const deleteStock = (req, res) => {
  const sql = "call DeleteStock(?)";
  db.query(sql, req.params.id, (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Stock deleted successfully" });
  });
};
