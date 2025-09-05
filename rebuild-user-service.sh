#!/bin/bash

# Скрипт для пересборки и развертывания User Service
# Используется для исправления проблем с 502 Bad Gateway

echo "🔄 Пересборка User Service..."

# Переходим в директорию проекта
cd /root/tutuu-market-eco-mvp

# Останавливаем user-service
echo "⏹️ Остановка user-service..."
docker-compose stop user-service

# Удаляем старый контейнер
echo "🗑️ Удаление старого контейнера..."
docker-compose rm -f user-service

# Пересобираем user-service
echo "🔨 Пересборка user-service..."
docker-compose build --no-cache user-service

# Запускаем user-service
echo "🚀 Запуск user-service..."
docker-compose up -d user-service

# Ждем запуска
echo "⏳ Ожидание запуска сервиса..."
sleep 10

# Проверяем статус
echo "✅ Проверка статуса..."
docker-compose ps user-service

# Проверяем логи
echo "📋 Последние логи:"
docker-compose logs --tail=20 user-service

# Проверяем health check
echo "🏥 Health check:"
curl -s http://localhost:3001/health || echo "Health check failed"

echo "✅ Пересборка завершена!"
