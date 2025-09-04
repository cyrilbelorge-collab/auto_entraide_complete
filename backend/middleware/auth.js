const jwt = require('jsonwebtoken');

exports.authenticate = (req, res, next) => {
  try {
    const header = req.header('Authorization') || '';
    const token = header.startsWith('Bearer ') ? header.slice(7) : null;
    if (!token) return res.status(401).json({ error: 'Token manquant' });
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // { userId, email, isProfessional }
    next();
  } catch (e) {
    return res.status(401).json({ error: 'Token invalide' });
  }
};

exports.optionalAuth = (req, _res, next) => {
  try {
    const header = req.header('Authorization') || '';
    const token = header.startsWith('Bearer ') ? header.slice(7) : null;
    if (token) req.user = jwt.verify(token, process.env.JWT_SECRET);
  } catch (_) {}
  next();
};