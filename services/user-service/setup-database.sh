#!/bin/bash

echo "🚀 Настройка базы данных для User Service..."

# Создаем .env файл с правильными настройками
cat > .env << EOF
# Environment variables for User Service
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/tutuu_users"
JWT_SECRET="your-super-secret-jwt-key-change-in-production"
JWT_EXPIRES_IN="7d"
REFRESH_TOKEN_EXPIRES_IN="30d"
PASSWORD_SALT_ROUNDS=12

# Redis configuration
REDIS_URL="redis://localhost:6379"

# Service configuration
PORT=3001
HOST=0.0.0.0

# Logging
LOG_LEVEL=info
EOF

echo "✅ .env файл создан"

# Генерируем Prisma Client
echo "🔨 Генерируем Prisma Client..."
npx prisma generate

# Создаем миграцию
echo "📊 Создаем миграцию базы данных..."
npx prisma migrate dev --name init-user-service

echo "✅ База данных настроена!"
echo "📝 Для применения миграций в production используйте: npx prisma migrate deploy"
