import db from "../config/mysql.js";

export const readAccount = (req, res) => {
  const sql = "CALL ReadAccount(?)";
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

export const createAccount = (req, res) => {
  const sql = "call CreateAccount(?, ?, ?)";
  const { username, email, password } = req.body;
  if (!username || !email || !password) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(sql, [username, email, password], (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(201).json({ message: "Account created successfully" });
  });
};

export const updateAccount = (req, res) => {
  const sql = "call UpdateAccount(?, ?, ?, ?)";
  const { id } = req.params;
  const { username, email, password } = req.body;
  if (!id) {
    return res.status(400).json({ error: "Params must be a number" });
  }
  if (!username || !email || !password) {
    return res.status(400).json({ error: "All fields are required" });
  }
  db.query(sql, [id, username, email, password], (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(200).json({ message: "Account updated successfully" });
  });
};

export const deleteAccount = (req, res) => {
  const sql = "call DeleteAccount(?)";
  const { id } = req.params;
  db.query(sql, [id], (err) => {
    if (err) {
      return res.status(400).json({ error: "Params must be a number" });
    }
    res.status(200).json({ message: "Account deleted successfully" });
  });
};
