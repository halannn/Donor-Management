import express from "express";
import db from "./config/mysql.js";
import facilitatorRouter from "./routes/facilitator.js";
import donorRouter from "./routes/donor.js";
import dotenv from "dotenv";
dotenv.config();
const app = express();

app.use("/facilitator", facilitatorRouter);
app.use("/donor", donorRouter);
app.listen(3000, () => {
  console.log("Server is running on port 3000");
  //Connet to database
  db.connect((err) => {
    if (err) {
      throw err;
    }
    console.log("Connected to database...");
  });
});