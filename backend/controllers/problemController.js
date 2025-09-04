const pool = require('../config/database');

exports.create = async (req, res) => {
  try {
    const { title, description, vehicle_info, dtc_codes = [] } = req.body;
    const author = req.user?.userId || null;
    const { rows } = await pool.query(
      `INSERT INTO problems (title, description, vehicle_info, dtc_codes, author, status)
       VALUES ($1,$2,$3,$4,$5,'non résolu')
       RETURNING *`,
      [title, description, vehicle_info, JSON.stringify(dtc_codes), author]
    );
    res.status(201).json(rows[0]);
  } catch (e) {
    console.error('create problem:', e);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

exports.list = async (req, res) => {
  try {
    const { vehicle, dtc, status, q } = req.query;
    const where = [];
    const params = [];
    if (vehicle) {
      params.push(`%${vehicle}%`);
      where.push(`(vehicle_info->>'brand' ILIKE $${params.length} OR vehicle_info->>'model' ILIKE $${params.length})`);
    }
    if (dtc) {
      params.push(`["${dtc}"]`);
      where.push(`dtc_codes @> $${params.length}::jsonb`);
    }
    if (status) {
      params.push(status);
      where.push(`status=$${params.length}`);
    }
    if (q) {
      params.push(`%${q}%`);
      where.push(`(title ILIKE $${params.length} OR description ILIKE $${params.length})`);
    }
    const sql =
      `SELECT p.*, 
              (SELECT COUNT(*) FROM solutions s WHERE s.problem_id=p.id) AS solution_count,
              EXISTS (SELECT 1 FROM solutions s WHERE s.problem_id=p.id AND s.is_accepted=true) AS has_accepted_solution
       FROM problems p` +
      (where.length ? ` WHERE ${where.join(' AND ')}` : '') +
      ' ORDER BY created_at DESC LIMIT 100';
    const { rows } = await pool.query(sql, params);
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

exports.get = async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM problems WHERE id=$1', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Introuvable' });
    res.json(rows[0]);
  } catch (e) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};