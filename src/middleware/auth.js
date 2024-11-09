// FILE: middleware/auth.js
export const isAdmin = (req, res, next) => {
  const user = req.user; // Assuming req.user is populated with the authenticated user's info

  if (user && user.role === 'admin') {
    next(); // User is admin, proceed to the next middleware/route handler
  } else {
    res.status(403).json({ error: "Access denied. Admins only." });
  }
};