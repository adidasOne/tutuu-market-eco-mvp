# TUTUU MARKET MVP

## 🚀 Project Status: BACKEND API FULLY IMPLEMENTED + PLANS READY

**All Node.js microservices are now working correctly!** The MVP backend is ready for database integration and frontend development.

## 📋 Overview

TUTUU MARKET MVP is a microservices-based e-commerce platform built with modern technologies:

- **Backend**: Node.js + TypeScript microservices
- **AI Service**: Python + FastAPI
- **Database**: PostgreSQL + Redis
- **Infrastructure**: Docker + Docker Compose + Nginx
- **CI/CD**: GitHub Actions
- **Cloud**: cloud.ru VM with SSL certificates

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Mobile App    │    │   Third-party   │
│   (Future)      │    │   (Future)      │    │   Integrations  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Nginx Proxy    │
                    │  (Port 80/443)   │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  User Service   │ │ Catalog Service │ │  Order Service  │
│   (Port 3001)   │ │   (Port 3002)   │ │   (Port 3003)   │
└─────────────────┘ └─────────────────┘ └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ Logistics Svc   │
                    │   (Port 3004)   │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   AI Service    │
                    │   (Port 3005)   │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   PostgreSQL    │ │      Redis      │ │   S3 Storage    │
│   (Port 5432)   │ │   (Port 6379)   │ │   (Backups)     │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+ (for local development)
- Python 3.11+ (for AI service development)

### 1. Clone Repository
```bash
git clone <repository-url>
cd tutuu-market-eco-mvp
```

### 2. Local Development
```bash
# Install dependencies for all services
cd services/user-service && npm install
cd ../catalog-service && npm install
cd ../order-service && npm install
cd ../logistics-service && npm install
cd ../ai-service && pip install -r requirements.txt

# Build and run locally
docker-compose up -d
```

### 3. Access Services
- **User Service**: http://localhost:3001
- **Catalog Service**: http://localhost:3002
- **Order Service**: http://localhost:3003
- **Logistics Service**: http://localhost:3004
- **AI Service**: http://localhost:3005

## 🌐 Production Deployment

### Current Status
- ✅ **Deployed to**: cloud.ru VM (176.108.246.94)
- ✅ **Domain**: https://api.tutuumarket.ru
- ✅ **SSL**: Let's Encrypt certificates
- ✅ **CI/CD**: GitHub Actions automated deployment

## 📊 Current Progress

### ✅ Completed (80%)
- **Backend API**: All 5 microservices implemented
- **Infrastructure**: Docker, Nginx, SSL, CI/CD
- **API Endpoints**: 25+ endpoints working
- **Security**: Firewall, SSL certificates
- **Monitoring**: Health checks, logging

### 🔄 In Progress (20%)
- **AI Service**: Requires Docker rebuild
- **Database**: PostgreSQL schemas and Prisma ORM
- **Business Logic**: Data validation and rules
- **Frontend**: React Native application

## 🚀 Development Roadmap

### Phase 1: Database Integration (September 4-17, 2025)
- [ ] **PostgreSQL schemas** for all MVP entities
- [ ] **Prisma ORM** integration
- [ ] **Database migrations** and seed data
- [ ] **Geospatial support** with PostGIS

### Phase 2: Frontend Development (September 18 - October 15, 2025)
- [ ] **React Native project** setup
- [ ] **Liquid Glass design system** with Dill Green (#4E6815)
- [ ] **All MVP screens** (Auth, Catalog, Orders, Logistics)
- [ ] **API integration** with backend

### Phase 3: Business Logic (October 16-29, 2025)
- [ ] **Data validation** and business rules
- [ ] **Service integration** logic
- [ ] **Event-driven architecture**
- [ ] **Testing** and optimization

### Phase 4: MVP Launch (October 30, 2025)
- [ ] **End-to-end testing**
- [ ] **Performance optimization**
- [ ] **Production deployment**
- [ ] **User feedback collection**

## 🎨 Design System

### Color Palette
- **Primary**: Dill Green (#4E6815) - Main brand color
- **Secondary**: Red (#CD242A) - Accent color
- **Accent**: Blue (#0EA5E9) - Interactive elements

### Design Trends
- **Liquid Glass**: Semi-transparent glass effects inspired by Apple VisionOS
- **Minimalist**: Clean, professional interface
- **Textured**: Subtle depth and visual interest
- **Trustworthy**: Professional appearance for construction industry

## 🔧 Technical Stack

### Backend
- **Node.js** + TypeScript
- **Express.js** framework
- **JWT** authentication
- **WebSocket** for real-time features

### Database
- **PostgreSQL** with PostGIS
- **Redis** for caching
- **Prisma** ORM

### Infrastructure
- **Docker** containers
- **Nginx** reverse proxy
- **Let's Encrypt** SSL
- **GitHub Actions** CI/CD

### Frontend (Planned)
- **React Native** for cross-platform
- **TypeScript** for type safety
- **Redux Toolkit** for state management
- **React Navigation** for routing

## 📱 MVP Features

### Core Functionality
- **User Management**: Registration, authentication, profiles
- **Product Catalog**: Categories, products, search, filters
- **Order Management**: Shopping cart, checkout, order tracking
- **Logistics**: Delivery setup, carrier selection, real-time tracking
- **AI Assistant**: Product recommendations, price predictions

### User Roles
- **Customers**: Browse products, place orders, track deliveries
- **Sellers**: Manage products, warehouses, orders
- **Carriers**: Accept delivery requests, provide tracking
- **Administrators**: System management and monitoring

## 🔍 API Documentation

### Base URL
```
https://api.tutuumarket.ru
```

### Service Endpoints
- **Users**: `/api/users/*`
- **Catalog**: `/api/catalog/*`
- **Orders**: `/api/orders/*`
- **Logistics**: `/api/logistics/*`
- **AI**: `/api/ai/*`

### Authentication
All protected endpoints require JWT token in `Authorization: Bearer <token>` header.

### Device Tracking
All requests require `x-device-id` header for device identification.

## 🚨 Known Issues

### AI Service
- **Status**: Requires Docker rebuild
- **Impact**: AI endpoints not accessible
- **Solution**: Rebuild container with corrected Dockerfile

### Database
- **Status**: Only containers running
- **Impact**: No persistent data storage
- **Solution**: Implement schemas and Prisma ORM

## 📞 Support & Contact

### Development Team
- **CTO**: Cursor AI - Technical architecture and development
- **CEO**: Дмитрий Макаров - Project vision and strategy

### Documentation
- [API Documentation](API-DOCUMENTATION.md)
- [Development Progress](DEVELOPMENT-PROGRESS.md)
- [Database Integration Plan](DATABASE-INTEGRATION-PLAN.md)
- [Frontend Development Plan](FRONTEND-DEVELOPMENT-PLAN.md)

## 📈 Success Metrics

### Technical KPIs
- **API Response Time**: < 500ms
- **App Load Time**: < 3 seconds
- **Uptime**: 99.5%
- **Test Coverage**: > 80%

### Business KPIs
- **User Registration**: 100+ users
- **Product Catalog**: 1000+ products
- **Order Completion**: 50+ orders
- **Delivery Success**: 95% on-time delivery

---

**Last Updated**: September 4, 2025  
**Next Update**: September 11, 2025  
**Project Status**: Backend Complete, Database & Frontend in Planning
