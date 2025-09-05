#!/bin/bash

# Скрипт для исправления nginx конфигурации
# Добавляет поддержку api.tutuumarket.ru домена

echo "🔧 Исправление nginx конфигурации..."

# Обновляем nginx конфигурацию
echo "📝 Обновление nginx конфигурации..."
cp nginx-mvp.conf /etc/nginx/sites-available/tutuu-market

# Создаем символическую ссылку
echo "🔗 Создание символической ссылки..."
ln -sf /etc/nginx/sites-available/tutuu-market /etc/nginx/sites-enabled/

# Удаляем дефолтную конфигурацию
echo "🗑️ Удаление дефолтной конфигурации..."
rm -f /etc/nginx/sites-enabled/default

# Проверяем конфигурацию
echo "✅ Проверка nginx конфигурации..."
nginx -t

if [ $? -eq 0 ]; then
    echo "🔄 Перезагрузка nginx..."
    systemctl reload nginx
    echo "✅ Nginx конфигурация обновлена!"
else
    echo "❌ Ошибка в nginx конфигурации!"
    exit 1
fi

# Проверяем статус
echo "📊 Статус nginx:"
systemctl status nginx --no-pager -l

echo "🎯 Проверка доступности API:"
curl -s https://api.tutuumarket.ru/api/users/health || echo "User Service недоступен"
curl -s https://api.tutuumarket.ru/api/catalog/health || echo "Catalog Service недоступен"

echo "✅ Исправление завершено!"
