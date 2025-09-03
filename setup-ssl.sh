#!/bin/bash

# Скрипт установки SSL сертификата Let's Encrypt для mvp.tutuumarket.ru
# Запускать от root пользователя

set -e

DOMAIN="mvp.tutuumarket.ru"
EMAIL="admin@tutuumarket.ru"

echo "🔐 Установка SSL сертификата для $DOMAIN..."

# Обновление системы
apt update

# Установка certbot
apt install -y certbot python3-certbot-nginx

# Проверка доступности домена
echo "📡 Проверка доступности домена $DOMAIN..."
if ! nslookup $DOMAIN > /dev/null 2>&1; then
    echo "❌ Ошибка: домен $DOMAIN недоступен"
    exit 1
fi

# Получение SSL сертификата
echo "📜 Получение SSL сертификата..."
certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --non-interactive

# Проверка автообновления
echo "🔄 Настройка автообновления сертификата..."
systemctl enable certbot.timer
systemctl start certbot.timer

# Проверка статуса
echo "✅ Проверка статуса сертификата..."
certbot certificates

echo "🎉 SSL сертификат успешно установлен для $DOMAIN!"
echo "🌐 Проверьте работу по адресу: https://$DOMAIN"
