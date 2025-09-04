#!/bin/bash

echo "🚀 Пересборка AI Service для TUTUU MARKET MVP..."

# Останавливаем AI Service
echo "📦 Останавливаем AI Service..."
docker stop tutuu_ai_service_prod 2>/dev/null || echo "AI Service не запущен"

# Удаляем старый контейнер
echo "🗑️ Удаляем старый контейнер..."
docker rm tutuu_ai_service_prod 2>/dev/null || echo "Старый контейнер не найден"

# Удаляем старый образ
echo "🧹 Удаляем старый образ..."
docker rmi tutuu-market-eco-mvp_ai-service 2>/dev/null || echo "Старый образ не найден"

# Пересобираем AI Service
echo "🔨 Пересобираем AI Service..."
docker-compose -f docker-compose.prod.yml --profile prod build ai-service

# Запускаем AI Service
echo "🚀 Запускаем AI Service..."
docker-compose -f docker-compose.prod.yml --profile prod up -d ai-service

# Проверяем статус
echo "📊 Проверяем статус..."
sleep 5
docker ps | grep ai_service

echo "✅ AI Service пересобран и запущен!"
echo "🔍 Проверьте логи: docker logs tutuu_ai_service_prod"
echo "🌐 Тест API: curl http://localhost:3005/health"
