const pool = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

class User {
  static async create(userData) {
    const { email, password, name, phone, isProfessional = false, qualifications = null } = userData;
    const hashed = await bcrypt.hash(password, 12);
    const sql = `
      INSERT INTO users (email, password, name, phone, is_professional, qualifications, reputation_score, referral_balance)
      VALUES ($1,$2,$3,$4,$5,$6,0,0)
      RETURNING id, email, name, is_professional, reputation_score, created_at`;
    const { rows } = await pool.query(sql, [email, hashed, name, phone, isProfessional, qualifications]);
    return rows[0];
  }

  static async findByEmail(email) {
    const { rows } = await pool.query('SELECT * FROM users WHERE email=$1', [email]);
    return rows[0];
  }

  static async findPublicById(id) {
    const { rows } = await pool.query(
      'SELECT id, email, name, phone, is_professional, qualifications, reputation_score, referral_balance, created_at FROM users WHERE id=$1',
      [id]
    );
    return rows[0];
  }

  static generateToken(user) {
    return jwt.sign(
      { userId: user.id, email: user.email, isProfessional: !!user.is_professional },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );
  }
}

module.exports = User;