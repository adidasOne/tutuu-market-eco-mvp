#!/bin/bash

# Скрипт для диагностики проблем с User Service

echo "🔍 Диагностика User Service..."

# Проверяем статус контейнеров
echo "📊 Статус Docker контейнеров:"
docker ps -a | grep user

# Проверяем логи User Service
echo "📋 Логи User Service:"
docker logs tutuu_user_service_prod --tail=20

# Проверяем, слушает ли порт 3001
echo "🔌 Проверка порта 3001:"
netstat -tlnp | grep 3001 || echo "Порт 3001 не слушается"

# Проверяем подключение к User Service напрямую
echo "🌐 Проверка подключения к User Service:"
curl -s http://localhost:3001/health || echo "User Service недоступен на localhost:3001"

# Проверяем nginx конфигурацию
echo "⚙️ Проверка nginx конфигурации:"
nginx -t

# Проверяем nginx логи
echo "📋 Nginx error логи:"
tail -10 /var/log/nginx/error.log

# Проверяем nginx access логи
echo "📋 Nginx access логи:"
tail -10 /var/log/nginx/access.log

# Проверяем, какие процессы слушают порты
echo "🔌 Процессы на портах:"
ss -tlnp | grep -E ":(3001|80|443)"

echo "✅ Диагностика завершена!"
