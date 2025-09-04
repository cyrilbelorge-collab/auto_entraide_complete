const pool = require('../config/database');
const User = require('../models/User');
const bcrypt = require('bcryptjs');

exports.register = async (req, res) => {
  try {
    const { email, password, name, phone, isProfessional, qualifications } = req.body;
    if (!email || !password || !name) return res.status(400).json({ error: 'Champs requis manquants' });

    const exists = await User.findByEmail(email);
    if (exists) return res.status(400).json({ error: 'Utilisateur déjà existant' });

    const user = await User.create({ email, password, name, phone, isProfessional, qualifications });
    const token = User.generateToken(user);
    res.status(201).json({ token, user });
  } catch (e) {
    console.error('register error:', e);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findByEmail(email);
    if (!user) return res.status(401).json({ error: 'Identifiants invalides' });

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return res.status(401).json({ error: 'Identifiants invalides' });

    const token = User.generateToken(user);
    const pub = await User.findPublicById(user.id);
    res.json({ token, user: pub });
  } catch (e) {
    console.error('login error:', e);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

exports.me = async (req, res) => {
  try {
    const me = await User.findPublicById(req.user.userId);
    res.json({ user: me });
  } catch (e) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};