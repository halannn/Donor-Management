import db from "../config/mysql.js";

export const getFacilitator = (req, res) => {
  const sql = "call ReadFacilitator()";
  db.query(sql, (err, results) => {
    if (err) return res.status(500);
    res.json(results[0]);
  });
};

export const getFacilitatorById = (req, res) => {
  const sql = "call ReadFacilitatorById(?)";
  db.query(sql, [req.params.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};

export const getFacilitatorByType = (req, res) => {
  const sql = "call ReadFacilitatorByType(?)";
  db.query(sql, [req.params.type], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};

export const getFacilitatorDonor = (req, res) => {
  const sql = "call ReadFacilitatorDonor()";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};

export const getFacilitatorTransfusion = (req, res) => {
  const sql = "call ReadFacilitatorTransfusion()";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};

export const getFacilitatorCostumerByYear = (req, res) => {
  const sql = "call ReadFacilitatorCostumerByYear(?)";
  db.query(sql, [req.params.year], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};

export const getFacilitatorStock = (req, res) => {
  const sql = "call ReadFacilitatorStock()";
  db.query(sql, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.length === 0) {
      return res.status(404).json({ message: "Facilitator not found" });
    }
    res.json(result[0]);
  });
};

export const createFacilitator = (req, res) => {
  const sql = "call CreateFacilitator(?, ?, ? ,?)";
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
