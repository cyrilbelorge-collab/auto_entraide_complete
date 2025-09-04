# Auto Entraide - Guide d'Installation

## 📦 Contenu de l'Archive

Cette archive contient l'application complète Auto Entraide :

### 🎯 Frontend Flutter (`auto_entraide_flutter/`)
- Application cross-platform (web, iOS, Android)
- Interface utilisateur moderne avec Material Design
- Authentification, gestion des problèmes, codes DTC
- Configuré avec state management (Provider)

### 🔧 Backend Node.js (`backend/`)
- API REST complète avec Express.js
- Authentification JWT
- Base de données PostgreSQL
- Gestion des utilisateurs, problèmes, codes DTC

## 🚀 Installation

### Prérequis
- Node.js 18+ 
- Flutter SDK 3.29+
- PostgreSQL (ou utiliser un service cloud)

### Backend
```bash
cd backend
npm install
# Configurer les variables d'environnement dans .env
node server.js
```

### Frontend
```bash
cd auto_entraide_flutter
flutter pub get
flutter run -d web-server --web-port 5000
```

### Base de Données
```sql
-- Exécuter le fichier schema.sql pour créer les tables
psql your_database < backend/database/schema.sql
```

## 🔧 Configuration

1. **Backend** : Modifier le fichier `backend/.env` avec vos paramètres de base de données
2. **Frontend** : Vérifier l'URL de l'API dans `lib/services/api_service.dart`

## 📱 Utilisation

1. Démarrer le backend sur le port 3001
2. Démarrer le frontend sur le port 5000
3. Accéder à l'application via votre navigateur

L'application permet :
- Inscription/Connexion des utilisateurs
- Gestion des problèmes automobiles
- Recherche de codes DTC
- Interface responsive pour mobile et desktop