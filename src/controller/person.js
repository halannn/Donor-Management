import db from "../config/mysql.js";

export const readPerson = (req, res) => {
  const sql = "CALL ReadPerson(?)";
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

export const createPerson = (req, res) => {
  const sql = "CALL CreatePerson(?, ?, ?, ?, ?, ?, ?)";
  const { full_name, age, blood_type, gender, address, contact, account_id } =
    req.body;
  if (!full_name || !age || !blood_type || !gender || !address || !contact) {
    return res.status(400).json({ message: "All fields are required" });
  }
  db.query(
    sql,
    [full_name, age, blood_type, gender, address, contact, account_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Failed to create person" });
      }
      res.status(201).json({ message: "Person created successfully" });
    }
  );
};

export const updatePerson = (req, res) => {
  const sql = "CALL UpdatePerson(?, ?, ?, ?, ?, ?, ?, ?)";
  const { id } = req.params;
  const { full_name, age, blood_type, gender, address, contact, account_id } =
    req.body;
  if (isNaN(id)) {
    return res.status(400).json({ error: "Params must be a number" });
  }
  if (!full_name || !age || !blood_type || !gender || !address || !contact) {
    return res.status(400).json({ message: "All fields are required" });
  }
  db.query(
    sql,
    [id, full_name, age, blood_type, gender, address, contact, account_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Failed to update person" });
      }
      res.status(200).json({ message: "Person updated successfully" });
    }
  );
};

export const deletePerson = (req, res) => {
  const sql = "CALL DeletePerson(?)";
  const { id } = req.params;
  db.query(sql, [id], (err) => {
    if (err) {
      return res.status(500).json({ error: "Params must be a number" });
    }
    res.status(200).json({ message: "Person deleted successfully" });
  });
};
