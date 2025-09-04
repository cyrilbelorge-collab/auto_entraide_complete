// Serveur minimal pour démarrer
const express = require('express');
const app = express();

app.use(express.json());

// Route de test
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Auto Entraide API fonctionne!',
    timestamp: new Date().toISOString()
  });
});

// Route pour l'authentification (simulation temporaire)
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  // Simulation d'authentification réussie
  if (email && password) {
    res.json({
      token: 'demo-token-123',
      user: {
        id: 1,
        email: email,
        name: 'Utilisateur Demo',
        is_professional: false,
        reputation_score: 0,
        referral_balance: 0,
        created_at: new Date().toISOString()
      }
    });
  } else {
    res.status(400).json({ error: 'Email et mot de passe requis' });
  }
});

// Route pour l'inscription (simulation temporaire)
app.post('/api/auth/register', (req, res) => {
  const { email, password, name } = req.body;
  
  if (email && password && name) {
    res.status(201).json({
      token: 'demo-token-123',
      user: {
        id: 1,
        email: email,
        name: name,
        is_professional: false,
        reputation_score: 0,
        referral_balance: 0,
        created_at: new Date().toISOString()
      }
    });
  } else {
    res.status(400).json({ error: 'Champs requis manquants' });
  }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 API Auto Entraide (simple) démarrée sur le port ${PORT}`);
});