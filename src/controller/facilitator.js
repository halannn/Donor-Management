import db from "../config/mysql.js";

export const readFacilitator = (req, res) => {
  const sql = "call ReadFacilitator(?)";
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

export const readFacilitatorByType = (req, res) => {
  const sql = "call ReadFacilitatorByType(?)";
  const { type } = req.query;
  db.query(sql, [type], (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(400).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const readFacilitatorDonor = (req, res) => {
  const sql = "call ReadFacilitatorDonor()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(400).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const readFacilitatorTransfusion = (req, res) => {
  const sql = "call ReadFacilitatorTransfusion()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(400).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const readFacilitatorStock = (req, res) => {
  const sql = "call ReadFacilitatorStock()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(400).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const createFacilitator = (req, res) => {
  const sql = "call CreateFacilitator(?, ?, ?, ?)";
  const { facilitator_name, facilitator_type, address, contact } = req.body;
  if (!facilitator_name || !facilitator_type || !address || !contact) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [facilitator_name, facilitator_type, address, contact],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Facilitator created successfully" });
    }
  );
};

export const updateFacilitator = (req, res) => {
  const sql = "call UpdateFacilitator(?, ?, ?, ?, ?)";
  const { id } = req.params;
  const { facilitator_name, facilitator_type, address, contact } = req.body;
  if (isNaN(id)) {
    return res.status(400).json({ error: "Params must be a number" });
  }
  if (!facilitator_name || !facilitator_type || !address || !contact) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(
    sql,
    [id, facilitator_name, facilitator_type, address, contact],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(200).json({ message: "Facilitator updated successfully" });
    }
  );
};

export const deleteFacilitator = (req, res) => {
  const sql = "call DeleteFacilitator(?)";
  const { id } = req.params;
  db.query(sql, [id], (err) => {
    if (err) {
      return res.status(400).json({ message: "Params must be a number" });
    }
    res.status(200).json({ message: "Facilitator deleted successfully" });
  });
};
