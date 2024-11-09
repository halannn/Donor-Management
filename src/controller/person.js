import db from "../config/mysql.js";

export const getPerson = (req, res) => {
  db.query("CALL ReadPerson()", (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Failed to fetch person data" });
    }
    res.json(result[0]);
  });
};

export const getPersonById = (req, res) => {
  const sql = "CALL ReadPersonById(?)";
  const { id } = req.params;

  if (isNaN(id)) {
    return res.status(400).json({ error: "Person ID must be a number" });
  }

  db.query(sql, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Failed to fetch person data" });
    }

    const person = result[0][0];
    if (!person) {
      return res.status(404).json({ error: "Person not found" });
    }

    res.json(person);
  });
};

export const createPerson = (req, res) => {
  const sql = "CALL CreatePerson(?, ?, ?, ?, ?, ?, ?)";
  const { full_name, age, blood_type, gender, address, contact, account_id } =
    req.body;

  if (
    !full_name ||
    !age ||
    !blood_type ||
    !gender ||
    !address ||
    !contact ||
    !account_id
  ) {
    return res.status(400).json({ message: "All fields are required" });
  }

  db.query(
    sql,
    [full_name, age, blood_type, gender, address, contact, account_id],
    (err, result) => {
      if (err) {
        console.error("Database error:", err);
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
    return res.status(400).json({ error: "Person ID must be a number" });
  }

  if (
    !full_name ||
    !age ||
    !blood_type ||
    !gender ||
    !address ||
    !contact ||
    !account_id
  ) {
    return res.status(400).json({ message: "All fields are required" });
  }

  db.query(
    sql,
    [id, full_name, age, blood_type, gender, address, contact, account_id],
    (err, result) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ error: "Failed to update person" });
      }

      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "Person not found" });
      }

      res.status(200).json({ message: "Person updated successfully" });
    }
  );
};

export const deletePerson = (req, res) => {
  const sql = "CALL DeletePerson(?)";
  const { id } = req.params;

  if (isNaN(id)) {
    return res.status(400).json({ error: "Person ID must be a number" });
  }

  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error("Database error:", err);
      return res.status(500).json({ error: "Failed to delete person" });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Person not found" });
    }

    res.status(200).json({ message: "Person deleted successfully" });
  });
};
