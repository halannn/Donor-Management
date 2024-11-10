import db from "../config/mysql.js";

export const getAccount = (req, res) => {
  const sql = "CALL ReadPerson()";
  db.query =
    (sql,
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.length === 0) {
        return res.status(404).json({ message: "Account not found" });
      }
      res.json(result[0]);
    });
};

export const getAccountById = (req, res) => {
  const sql = "CALL ReadAccountById(?)";
  const { id } = req.params;
  if (!id) {
    return res.status(400).json({ error: "Account ID is required" });
  }
  db.query(sql, id, (err, result) =>{
    if (err) {

    }

  })
};
