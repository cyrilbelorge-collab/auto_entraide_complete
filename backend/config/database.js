// backend/config/database.js
const { Pool } = require('pg');

const makePool = () => {
  if (process.env.DATABASE_URL) {
    // Railway / la plupart des DB managées fournissent une URL unique
    return new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: { rejectUnauthorized: false }, // utile si la DB force SSL
    });
  }
  // fallback: variables séparées
  return new Pool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 5432),
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  });
};

module.exports = makePool();
