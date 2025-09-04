require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const http = require('http');

const app = express();
app.use(helmet());
app.use(cors({ origin: process.env.FRONTEND_URL || '*', credentials: true }));
app.use(express.json({ limit: '10mb' }));

// Routes principales
app.use('/api/auth', require('./routes/auth'));
app.use('/api/dtc', require('./routes/dtc'));
app.use('/api/problems', require('./routes/problems'));

// Route de test
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Auto Entraide API fonctionne!' });
});

const server = http.createServer(app);

const PORT = +process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`🚀 API Auto Entraide démarrée sur le port ${PORT}`);
});