#!/bin/bash

# Скрипт резервного копирования PostgreSQL базы данных
# Запускать от root пользователя или пользователя с правами sudo

set -e

# Настройки
BACKUP_DIR="/var/backups/tutuu-market"
DB_NAME="tutuu_market"
DB_USER="postgres"
DB_HOST="localhost"
RETENTION_DAYS=7

# Создание директории для бэкапов
mkdir -p $BACKUP_DIR

# Имя файла бэкапа с timestamp
BACKUP_FILE="$BACKUP_DIR/tutuu_market_$(date +%Y%m%d_%H%M%S).sql"

echo "💾 Создание резервной копии базы данных $DB_NAME..."

# Создание бэкапа
if docker exec tutuu_postgres_prod pg_dump -U $DB_USER -h $DB_HOST $DB_NAME > $BACKUP_FILE; then
    echo "✅ Резервная копия создана: $BACKUP_FILE"
    
    # Сжатие бэкапа
    gzip $BACKUP_FILE
    echo "🗜️ Бэкап сжат: $BACKUP_FILE.gz"
    
    # Удаление старых бэкапов
    find $BACKUP_DIR -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete
    echo "🧹 Удалены бэкапы старше $RETENTION_DAYS дней"
    
    # Проверка размера
    BACKUP_SIZE=$(du -h "$BACKUP_FILE.gz" | cut -f1)
    echo "📊 Размер бэкапа: $BACKUP_SIZE"
    
else
    echo "❌ Ошибка создания резервной копии"
    exit 1
fi

echo "🎉 Резервное копирование завершено успешно!"
