# Auto Entraide Application

## Overview

Auto Entraide is a comprehensive automotive assistance platform consisting of a Flutter mobile/web application and a Node.js backend API. The system provides multiple automotive-related services including breakdown assistance, diagnostic trouble code (DTC) management, real-time chat functionality, OBD2 integration, vehicle maintenance logs, referral systems, plugin architecture, and analytics capabilities.

## User Preferences

Preferred communication style: Simple, everyday language.

## Recent Changes

### 2025-01-09: Flutter Frontend Implementation
- Créé l'application Flutter multi-plateforme avec support web, iOS et Android
- Architecture organisée avec services, providers, models et screens séparés
- Implémentation de l'authentification avec state management (Provider)
- Écrans principaux créés : accueil, connexion, problèmes, codes DTC
- Services API configurés pour communiquer avec le backend Node.js
- Workflow Flutter configuré et fonctionnel sur le port 5000
- Interface utilisateur Material Design avec navigation moderne (go_router)

## System Architecture

### Frontend Architecture
- **Framework**: Flutter with cross-platform support (iOS, Android, Web)
- **State Management**: Provider pattern for state management
- **Navigation**: Go Router for declarative routing
- **Networking**: HTTP package for API communication with Socket.IO client for real-time features
- **UI Components**: Material Design with Cupertino icons, Material Design icons, and SVG support
- **Caching**: Cached network images for optimized performance
- **Local Storage**: Shared preferences for client-side data persistence

### Backend Architecture
- **Runtime**: Node.js with Express.js framework
- **Authentication**: JWT-based authentication with bcryptjs for password hashing
- **Real-time Communication**: Socket.IO and WebSocket support for live chat and notifications
- **Security**: Helmet middleware for security headers, CORS configuration
- **File Handling**: Multer for file uploads with Sharp for image processing
- **Development**: Nodemon for development hot-reloading

### Data Storage Solutions
- **Primary Database**: PostgreSQL for structured data storage
- **Search Engine**: Elasticsearch for advanced search capabilities and analytics
- **Connection**: Native PostgreSQL driver (pg) for database operations

### Authentication and Authorization
- **Token-based Authentication**: JWT tokens for stateless authentication
- **Password Security**: bcryptjs for secure password hashing
- **Session Management**: Stateless design using JWT tokens

### API Architecture
- **RESTful Design**: Express.js-based REST API endpoints
- **Real-time Features**: Socket.IO integration for live chat and notifications
- **File Upload**: Multipart form data handling for image and document uploads
- **Error Handling**: Centralized error handling with appropriate HTTP status codes

### Hardware Integration
- **Bluetooth Connectivity**: Node-bluetooth package for OBD2 device communication
- **Automotive Diagnostics**: Integration capabilities for reading vehicle diagnostic data

## External Dependencies

### Third-party Services
- **Auto Data API**: External automotive data service (API key required)
- **Elasticsearch**: Search and analytics engine deployment
- **PostgreSQL**: Relational database system

### Development Tools
- **Package Management**: npm for Node.js dependencies, pub for Flutter packages
- **Environment Configuration**: dotenv for environment variable management
- **Development Server**: Nodemon for backend development

### Key Libraries and Frameworks
- **Backend**: Express.js, Socket.IO, bcryptjs, jsonwebtoken, multer, sharp, helmet
- **Frontend**: Flutter SDK, go_router, provider, http, socket_io_client, cached_network_image
- **Database**: PostgreSQL with native Node.js driver
- **Search**: Elasticsearch client for Node.js
- **Hardware**: node-bluetooth for OBD2 integration

### Infrastructure Requirements
- **Database Server**: PostgreSQL instance
- **Search Engine**: Elasticsearch cluster
- **File Storage**: Local file system with image processing capabilities
- **Real-time Services**: WebSocket server capabilities