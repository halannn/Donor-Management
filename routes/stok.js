const express = require("express");
const router = express.Router();
const mysql = require("mysql");
require('dotenv').config(); // Load environment variables from .env file

// Database connection
var db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});