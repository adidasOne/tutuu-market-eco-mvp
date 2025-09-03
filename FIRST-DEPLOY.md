# 🚀 Первый деплой TUTUU MARKET MVP

## 📋 Подготовка

### 1. Проверьте наличие всех файлов
Убедитесь, что в репозитории есть:
- `docker-compose.yml` - для локальной разработки
- `docker-compose.prod.yml` - для продакшена
- `nginx-mvp.conf` - конфигурация Nginx
- `setup-ssl.sh` - скрипт установки SSL
- `backup-db.sh` - скрипт резервного копирования
- `services/` - директория с микросервисами
- `.github/workflows/deploy.yml` - GitHub Actions workflow

### 2. Настройте GitHub Secrets
Следуйте инструкции в `GITHUB-SETUP.md` для добавления:
- `SSH_PRIVATE_KEY`
- `VM_IP`
- `VM_USER`

## 🔄 Процесс деплоя

### Шаг 1: Загрузите код в репозиторий
```bash
# Клонируйте репозиторий (если еще не сделали)
git clone https://github.com/adidasOne/tutuu-market-eco-mvp.git
cd tutuu-market-eco-mvp

# Добавьте все файлы
git add .

# Сделайте коммит
git commit -m "Initial MVP setup with CI/CD"

# Загрузите в GitHub
git push origin main
```

### Шаг 2: Запуск автоматического деплоя
1. Перейдите на вкладку **Actions** в GitHub
2. Должен запуститься workflow **Deploy MVP to cloud.ru**
3. Следите за выполнением в реальном времени

### Шаг 3: Проверка деплоя
После успешного деплоя проверьте:

#### На ВМ (176.108.246.94)
```bash
ssh -i tutuumarket_deploy dmitrimakarov@176.108.246.94

# Проверка контейнеров
docker ps

# Проверка логов
docker logs tutuu_user_service_prod
docker logs tutuu_catalog_service_prod
docker logs tutuu_order_service_prod
docker logs tutuu_logistics_service_prod
docker logs tutuu_ai_service_prod

# Проверка Nginx
sudo nginx -t
sudo systemctl status nginx
```

#### Проверка доступности сервисов
```bash
# Локально на ВМ
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
curl http://localhost:3004/health
curl http://localhost:3005/health

# С вашего компьютера
curl http://176.108.246.94:3001/health
```

## 🌐 Настройка SSL сертификата

### Автоматическая установка
```bash
ssh -i tutuumarket_deploy dmitrimakarov@176.108.246.94

# Перейдите в директорию проекта
cd /opt/tutuu-market

# Запустите скрипт установки SSL
sudo ./setup-ssl.sh
```

### Ручная установка (если автоматическая не сработала)
```bash
# Установка certbot
sudo apt install -y certbot python3-certbot-nginx

# Получение сертификата
sudo certbot --nginx -d mvp.tutuumarket.ru --email admin@tutuumarket.ru --agree-tos --non-interactive

# Проверка автообновления
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

## ✅ Проверка работоспособности

### 1. Проверка домена
Откройте в браузере: `https://mvp.tutuumarket.ru`

### 2. Проверка API endpoints
```bash
# Health check
curl https://mvp.tutuumarket.ru/health

# User service
curl https://mvp.tutuumarket.ru/api/users/health

# Catalog service
curl https://mvp.tutuumarket.ru/api/catalog/health

# Order service
curl https://mvp.tutuumarket.ru/api/orders/health

# Logistics service
curl https://mvp.tutuumarket.ru/api/logistics/health

# AI service
curl https://mvp.tutuumarket.ru/api/ai/health
```

### 3. Проверка резервного копирования
```bash
ssh -i tutuumarket_deploy dmitrimakarov@176.108.246.94

# Запуск тестового бэкапа
sudo /opt/tutuu-market/backup-db.sh

# Проверка файлов бэкапа
ls -la /var/backups/tutuu-market/
```

## 🚨 Устранение проблем

### Проблема: Сервисы не запускаются
```bash
# Проверка логов
docker logs tutuu_user_service_prod

# Проверка статуса контейнеров
docker ps -a

# Перезапуск сервисов
cd /opt/tutuu-market
docker-compose -f docker-compose.prod.yml --profile prod restart
```

### Проблема: Nginx не работает
```bash
# Проверка конфигурации
sudo nginx -t

# Проверка статуса
sudo systemctl status nginx

# Перезапуск
sudo systemctl restart nginx
```

### Проблема: SSL сертификат не работает
```bash
# Проверка сертификата
sudo certbot certificates

# Обновление сертификата
sudo certbot renew --dry-run
```

## 🎉 Готово!

После успешного деплоя у вас будет:
- ✅ Работающий MVP на `https://mvp.tutuumarket.ru`
- ✅ Автоматический деплой при push в main
- ✅ SSL сертификат Let's Encrypt
- ✅ Автоматическое резервное копирование БД
- ✅ Мониторинг состояния сервисов

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи в GitHub Actions
2. Проверьте логи на ВМ
3. Убедитесь, что все секреты настроены правильно
4. Проверьте доступность ВМ по SSH
