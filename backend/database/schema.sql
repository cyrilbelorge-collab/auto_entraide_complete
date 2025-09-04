-- Utilisateurs
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  is_professional BOOLEAN DEFAULT FALSE,
  qualifications TEXT,
  reputation_score INT DEFAULT 0,
  referral_balance NUMERIC(10,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Problèmes
CREATE TABLE IF NOT EXISTS problems (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  vehicle_info JSONB NOT NULL,
  dtc_codes JSONB DEFAULT '[]',
  author INT REFERENCES users(id),
  status VARCHAR(50) DEFAULT 'non résolu',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Solutions
CREATE TABLE IF NOT EXISTS solutions (
  id SERIAL PRIMARY KEY,
  problem_id INT REFERENCES problems(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  author INT REFERENCES users(id),
  is_professional BOOLEAN DEFAULT FALSE,
  is_accepted BOOLEAN DEFAULT FALSE,
  upvotes INT DEFAULT 0,
  downvotes INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Codes DTC (exemple de données)
CREATE TABLE IF NOT EXISTS dtc_codes (
  id SERIAL PRIMARY KEY,
  code VARCHAR(10) UNIQUE NOT NULL,
  domain VARCHAR(20),
  standard VARCHAR(10),
  system VARCHAR(100),
  title_fr VARCHAR(255),
  long_desc_fr TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Votes
CREATE TABLE IF NOT EXISTS votes (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  solution_id INT REFERENCES solutions(id) ON DELETE CASCADE,
  vote_type VARCHAR(10) CHECK (vote_type IN ('up','down')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (user_id, solution_id)
);

-- Insertion de quelques codes DTC d'exemple
INSERT INTO dtc_codes (code, domain, standard, system, title_fr, long_desc_fr) 
VALUES 
  ('P0420', 'Powertrain', 'OBD-II', 'Emissions', 'Efficacité du catalyseur faible', 'Le catalyseur ne fonctionne pas de manière efficace. Cela peut être dû à un catalyseur défaillant ou à un problème avec le capteur d''oxygène.'),
  ('P0171', 'Powertrain', 'OBD-II', 'Fuel', 'Mélange trop pauvre', 'Le système de carburant détecte un mélange air/carburant trop pauvre. Vérifiez les fuites d''air et le système d''injection.'),
  ('P0300', 'Powertrain', 'OBD-II', 'Ignition', 'Ratés d''allumage détectés', 'Des ratés d''allumage ont été détectés dans le moteur. Vérifiez les bougies d''allumage, les bobines et le système d''injection.')
ON CONFLICT (code) DO NOTHING;