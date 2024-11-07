const express = require("express");
const mysql = require("mysql");
require("dotenv").config(); // Load environment variables from .env file

// Database connection
var db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

//Connet to database
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log("Connected to database...");
});

const app = express();

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});

const facilitatorRouter = require("./routes/facilitator");
const donorRouter = require("./routes/donor");

app.use("/facilitator", facilitatorRouter);
app.use("/donor", donorRouter);
