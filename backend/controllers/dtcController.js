const pool = require('../config/database');

exports.list = async (req, res) => {
  try {
    const { code, q } = req.query;
    let sql = 'SELECT code, domain, standard, system, title_fr, long_desc_fr FROM dtc_codes';
    const params = [];
    if (code) {
      sql += ' WHERE code=$1';
      params.push(code);
    } else if (q) {
      sql += ' WHERE code ILIKE $1 OR title_fr ILIKE $1 OR long_desc_fr ILIKE $1';
      params.push(`%${q}%`);
    }
    sql += ' ORDER BY code';
    const { rows } = await pool.query(sql, params);
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

exports.get = async (req, res) => {
  try {
    const { rows } = await pool.query(
      'SELECT code, domain, standard, system, title_fr, long_desc_fr FROM dtc_codes WHERE code=$1',
      [req.params.code]
    );
    if (!rows.length) return res.status(404).json({ error: 'DTC introuvable' });
    res.json(rows[0]);
  } catch (e) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};