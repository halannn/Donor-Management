import db from "../config/mysql.js";
import dotenv from "dotenv";
dotenv.config();
import jwt from "jsonwebtoken";

export const loginAccount = (req, res) => {
  const sql = "CALL LoginAccount(?, ?)";
  const { username, password } = req.body;

  db.query(sql, [username, password], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }

    if (results[0].length === 0) {
      return res.status(401).json({ message: "Invalid username or password" });
    }

    const user = results[0][0];
    
    const accessToken = jwt.sign(
      { username: user.username, accountId: user.account_id, isAdmin: user.is_admin }, 
      process.env.ACCESS_TOKEN_SECRET, 
      { expiresIn: "1h" }
    );

    res.json({
      message: "Account login successful",
      accessToken: accessToken
    });
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
