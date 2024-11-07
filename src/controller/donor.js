import db from "../config/mysql.js";

export const getDonor = (req, res) => {
  const sql = "SELECT * FROM Donor";
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
};
