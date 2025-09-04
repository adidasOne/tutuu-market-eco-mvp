# AI Service - TUTUU MARKET MVP

## 🎯 Описание

AI Service предоставляет интеллектуальные функции для экосистемы TUTUU MARKET:
- **Рекомендации товаров** на основе пользовательских предпочтений
- **Прогнозирование цен** с использованием анализа рынка
- **Расчет смет строительства** с AI-анализом
- **Анализ рыночных трендов** и рекомендации

## 🚀 Быстрый старт

### Локальная разработка

```bash
# Установка зависимостей
pip install -r requirements.txt

# Запуск сервиса
python src/main.py

# Или через uvicorn
uvicorn src.main:app --host 0.0.0.0 --port 3005 --reload
```

### Docker

```bash
# Сборка образа
docker build -t tutuu-ai-service .

# Запуск контейнера
docker run -p 3005:3005 tutuu-ai-service
```

## 🔧 Пересборка в продакшене

### Автоматическая пересборка

```bash
# В корневой папке проекта
./rebuild-ai-service.sh
```

### Ручная пересборка

```bash
# Остановка сервиса
docker stop tutuu_ai_service_prod

# Удаление контейнера
docker rm tutuu_ai_service_prod

# Удаление образа
docker rmi tutuu-market-eco-mvp_ai-service

# Пересборка
docker-compose -f docker-compose.prod.yml --profile prod build ai-service

# Запуск
docker-compose -f docker-compose.prod.yml --profile prod up -d ai-service
```

## 📊 API Endpoints

### Health Check
```http
GET /health
```

### Root Information
```http
GET /
```

### Product Recommendations
```http
POST /recommendations
Content-Type: application/json
x-device-id: your-device-id

{
  "user_id": "user-123",
  "search_query": "кирпич",
  "category": "строительные материалы",
  "budget": 50000.0
}
```

### Price Prediction
```http
POST /price-prediction
Content-Type: application/json
x-device-id: your-device-id

{
  "product_id": "prod-123",
  "market_data": {"demand": "high", "supply": "stable"},
  "historical_prices": [1000.0, 1100.0, 1200.0]
}
```

### Construction Estimate
```http
POST /construction-estimate
Content-Type: application/json
x-device-id: your-device-id

{
  "project_type": "жилой дом",
  "area": 150.0,
  "materials": ["кирпич", "цемент", "доски"],
  "complexity": "средняя"
}
```

### Market Analysis
```http
GET /market-analysis
x-device-id: your-device-id
```

## 🧪 Тестирование

### Автоматические тесты

```bash
# В корневой папке проекта
python test-ai-service.py
```

### Ручное тестирование

```bash
# Health check
curl -H "x-device-id: test-device" http://localhost:3005/health

# Root endpoint
curl -H "x-device-id: test-device" http://localhost:3005/

# Recommendations
curl -X POST -H "Content-Type: application/json" \
  -H "x-device-id: test-device" \
  -d '{"user_id":"test","search_query":"кирпич"}' \
  http://localhost:3005/recommendations
```

## 📁 Структура проекта

```
ai-service/
├── src/
│   └── main.py              # Основной файл приложения
├── Dockerfile               # Docker конфигурация
├── requirements.txt         # Python зависимости
├── .dockerignore           # Исключения для Docker
└── README.md               # Этот файл
```

## 🔍 Логирование

Сервис ведет логи в двух местах:
- **stdout** - для Docker контейнера
- **ai_service.log** - файл логов

### Уровни логирования
- **INFO** - основные операции
- **ERROR** - ошибки и исключения

### Примеры логов
```
2025-09-04 10:30:15 - __main__ - INFO - 🚀 AI Service запущен
2025-09-04 10:30:16 - __main__ - INFO - Request: GET /health - Device ID: test-device
2025-09-04 10:30:16 - __main__ - INFO - Response: 200 - Process Time: 0.002s
```

## 🚨 Устранение неполадок

### Сервис не запускается
1. Проверьте логи: `docker logs tutuu_ai_service_prod`
2. Убедитесь, что порт 3005 свободен
3. Проверьте зависимости в requirements.txt

### Ошибки при сборке
1. Очистите Docker кэш: `docker system prune -a`
2. Пересоберите образ: `docker build --no-cache .`
3. Проверьте версию Python (должна быть 3.10)

### Проблемы с зависимостями
1. Обновите pip: `pip install --upgrade pip`
2. Установите зависимости по одной для выявления проблем
3. Проверьте совместимость версий

## 📈 Мониторинг

### Health Check
- Endpoint: `/health`
- Проверка: каждые 30 секунд
- Критерии: статус "healthy", время ответа < 1 секунды

### Метрики
- Время ответа API
- Количество запросов
- Ошибки и исключения
- Использование памяти и CPU

## 🔒 Безопасность

### Headers
- **x-device-id** - обязательный для всех запросов
- **Content-Type** - application/json для POST запросов

### Валидация
- Все входные данные валидируются через Pydantic
- Автоматическая обработка ошибок
- Логирование всех запросов

## 🚀 Развитие

### TODO
- [ ] Интеграция с реальными ML моделями
- [ ] Кэширование результатов
- [ ] Асинхронная обработка запросов
- [ ] Метрики производительности

### Планы
- Интеграция с TensorFlow/PyTorch
- Real-time обучение моделей
- A/B тестирование алгоритмов
- Масштабирование через Kubernetes

---

**Версия**: 1.0.0  
**Последнее обновление**: 4 сентября 2025  
**Статус**: Готов к пересборке ✅
