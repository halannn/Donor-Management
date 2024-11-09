import express from "express";
import db from "./config/mysql.js";
import facilitatorRouter from "./routes/facilitator.js";
import donorRouter from "./routes/donor.js";
import stokRouter from "./routes/stok.js";
import transfusionRouter from "./routes/transfusion.js";
import dotenv from "dotenv";
dotenv.config();

const app = express();

app.use("/api/stock", stokRouter);
app.use("/api/facilitator", facilitatorRouter);
app.use("/api/donor", donorRouter);
app.use("/api/transfusion", transfusionRouter);
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
