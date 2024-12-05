import dotenv from "dotenv";
dotenv.config();
import jwt from "jsonwebtoken";

export function verifyUser(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res
      .status(401)
      .json({ message: "Unauthorized, no token provided." });
  }

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Invalid or expired token." });
    }
    req.user = user;
    next();
  });
}

export function verifyAdmin(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = req.headers["authorization"]?.split(" ")[1];

  if (!token) {
    return res
      .status(403)
      .json({ message: "Access denied, no token provided." });
  }

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: "Invalid or expired token." });
    }

    const isAdmin = decoded.isAdmin; // Extract isAdmin property from the decoded token

    if (!isAdmin) {
      return res.status(403).json({ message: "Access denied, admin only." });
    }

    req.user = decoded;
    next();
  });
}
