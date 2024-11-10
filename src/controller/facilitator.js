import db from "../config/mysql.js";

export const getFacilitator = (req, res) => {
  const sql = "call ReadFacilitator(?)";
  const { id } = req.params;
  db.query(sql, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ message: "Params must be a number" });
    }
    if (results[0].length !== 1) {
      res.json(results[0]);
    } else {
      res.json(results[0][0]);
    }
  });
};

export const getFacilitatorByType = (req, res) => {
  const sql = "call ReadFacilitatorByType(?)";
  const { type } = req.query;
  if (!type) {
    return res.status(400).json({ message: "Facilitator type is required" });
  }
  db.query(sql, [type], (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const getFacilitatorDonor = (req, res) => {
  const sql = "call ReadFacilitatorDonor()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const getFacilitatorTransfusion = (req, res) => {
  const sql = "call ReadFacilitatorTransfusion()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const getFacilitatorStock = (req, res) => {
  const sql = "call ReadFacilitatorStock()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(results[0]);
  });
};

export const createFacilitator = (req, res) => {
  const sql = "call CreateFacilitator(?, ?, ?, ?)";
  const { facilitator_name, facilitator_type, address, contact } = req.body;
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
  const { facilitator_name, facilitator_type, address, contact } = req.body;
  db.query(
    sql,
    [req.params.id, facilitator_name, facilitator_type, address, contact],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Facilitator updated successfully" });
    }
  );
};

export const deleteFacilitator = (req, res) => {
  const sql = "call DeleteFacilitator(?)";
  db.query(sql, req.params.id, (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json({ message: "Facilitator deleted successfully" });
  });
};
