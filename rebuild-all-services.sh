#!/bin/bash

echo "🚀 Начинаем пересборку всех сервисов TUTUU MARKET..."

# Останавливаем все контейнеры
echo "🛑 Останавливаем все контейнеры..."
docker-compose -f docker-compose.prod.yml --profile prod down

# Удаляем старые образы
echo "🗑️ Удаляем старые образы..."
docker rmi $(docker images -q 'tutuu-market-*') 2>/dev/null || true

# Очищаем Docker cache
echo "🧹 Очищаем Docker cache..."
docker system prune -f

# Пересобираем все сервисы
echo "🔨 Пересобираем все сервисы..."
docker-compose -f docker-compose.prod.yml --profile prod build --no-cache

# Запускаем все сервисы
echo "▶️ Запускаем все сервисы..."
docker-compose -f docker-compose.prod.yml --profile prod up -d

# Проверяем статус
echo "📊 Проверяем статус контейнеров..."
docker ps

echo "✅ Пересборка завершена!"
echo "🎯 Все сервисы должны быть запущены"
echo "📝 Для просмотра логов используйте: docker-compose -f docker-compose.prod.yml --profile prod logs -f"
