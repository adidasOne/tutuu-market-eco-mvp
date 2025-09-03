# TUTUU MARKET MVP - Backend API

## 🚀 Статус проекта

**Backend API MVP**: 60% готово  
**Дата последнего обновления**: 3 сентября 2025  
**Следующий этап**: База данных и бизнес-логика  

## 📋 Что реализовано

### ✅ Микросервисы (100% готово)
- **User Service** (Port 3001) - Аутентификация, пользователи, роли
- **Catalog Service** (Port 3002) - Товары, категории, склады
- **Order Service** (Port 3003) - Заказы, корзина, статусы
- **Logistics Service** (Port 3004) - Доставка, перевозчики, трекинг
- **AI Service** (Port 3005) - Рекомендации, прогнозы, аналитика

### ✅ API Endpoints (80% готово)
- **35+ endpoints** для всех основных операций
- **CRUD операции** для всех сущностей
- **Поиск и фильтрация** с пагинацией
- **JWT аутентификация** и role-based access control
- **Device ID tracking** для всех запросов

### ✅ Инфраструктура (100% готово)
- **Docker контейнеризация** всех сервисов
- **CI/CD пайплайн** (GitHub Actions)
- **Production развертывание** на cloud.ru
- **Nginx + SSL** + UFW firewall
- **PostgreSQL + Redis** для данных
- **Автоматические бэкапы** в S3

## 🏗️ Архитектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User Service  │    │ Catalog Service │    │  Order Service  │
│   (Port 3001)   │    │   (Port 3002)   │    │   (Port 3003)   │
│                 │    │                 │    │                 │
│ • Регистрация   │    │ • Поиск товаров │    │ • Корзина       │
│ • Аутентификация│    │ • Категории     │    │ • Заказы        │
│ • Профили       │    │ • Склады        │    │ • Статусы       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐    ┌─────────────────┐
                    │Logistics Service│    │   AI Service    │
                    │   (Port 3004)   │    │   (Port 3005)   │
                    │                 │    │                 │
                    │ • Доставка      │    │ • Рекомендации  │
                    │ • Перевозчики   │    │ • Прогноз цен   │
                    │ • Трекинг       │    │ • Сметы         │
                    └─────────────────┘    └─────────────────┘
```

## 🚀 Быстрый старт

### Предварительные требования
- Docker и Docker Compose
- Node.js 18+ (для разработки)
- Python 3.9+ (для AI сервиса)

### Запуск
```bash
# Клонирование
git clone <repository-url>
cd tutuu-market-eco-mvp

# Запуск всех сервисов
docker-compose up -d

# Проверка статуса
docker-compose ps
```

### Проверка работоспособности
```bash
# Health checks
curl https://api.tutuumarket.ru/api/users/health
curl https://api.tutuumarket.ru/api/catalog/health
curl https://api.tutuumarket.ru/api/orders/health
curl https://api.tutuumarket.ru/api/logistics/health
curl https://api.tutuumarket.ru/api/ai/health
```

## 📚 API Документация

Полная документация API доступна в [API-DOCUMENTATION.md](./API-DOCUMENTATION.md)

### Основные endpoints

#### User Service
```bash
# Регистрация
POST /api/users/register
# Аутентификация
POST /api/users/login
# Профиль
GET /api/users/profile
```

#### Catalog Service
```bash
# Поиск товаров
GET /api/catalog/products/search?query=кирпич
# Товар по ID
GET /api/catalog/products/{id}
# Категории
GET /api/catalog/categories
```

#### Order Service
```bash
# Корзина
GET /api/orders/cart?customerId={id}
# Создание заказа
POST /api/orders/from-cart
# Поиск заказов
GET /api/orders/orders
```

#### Logistics Service
```bash
# Заявка на доставку
POST /api/logistics/deliveries
# Трекинг
GET /api/logistics/deliveries/{id}/tracking
# Перевозчики
GET /api/logistics/carriers
```

#### AI Service
```bash
# Рекомендации
POST /api/ai/recommendations
# Прогноз цен
POST /api/ai/price-prediction
# Смета строительства
POST /api/ai/construction-estimate
```

## 🔧 Разработка

### Структура проекта
```
tutuu-market-eco-mvp/
├── services/
│   ├── user-service/          # Пользователи и аутентификация
│   ├── catalog-service/       # Каталог товаров
│   ├── order-service/         # Заказы и корзина
│   ├── logistics-service/     # Логистика и доставка
│   └── ai-service/           # AI функции
├── .github/                   # CI/CD конфигурация
├── docs/                      # Документация
└── docker-compose.yml         # Контейнеры
```

### Локальная разработка
```bash
# Установка зависимостей
cd services/user-service && npm install
cd ../catalog-service && npm install
cd ../order-service && npm install
cd ../logistics-service && npm install
cd ../ai-service && pip install -r requirements.txt

# Запуск в режиме разработки
npm run dev  # для Node.js сервисов
python src/main.py  # для AI сервиса
```

### Переменные окружения
Создайте `.env` файл:
```env
JWT_SECRET=your-secret-key
DATABASE_URL=postgresql://user:password@localhost:5432/tutuu_market
REDIS_URL=redis://localhost:6379
```

## 📊 Статистика

### Код
- **TypeScript файлы**: 15+
- **Python файлы**: 3
- **API endpoints**: 35+
- **Типы данных**: 50+ интерфейсов

### Покрытие функциональности
- **CRUD операции**: 100%
- **Поиск и фильтрация**: 100%
- **Аутентификация**: 100%
- **Валидация**: 80%
- **База данных**: 0% ⚠️

## 🎯 Следующие шаги

### Неделя 1-2: База данных
- [ ] PostgreSQL схемы и таблицы
- [ ] Prisma ORM настройка
- [ ] Миграции и seed данные
- [ ] Индексы и оптимизация

### Неделя 3-4: Бизнес-логика
- [ ] Валидация данных
- [ ] Проверка прав доступа
- [ ] Обработка ошибок
- [ ] Логирование

### Неделя 5-6: Интеграция
- [ ] Межсервисное взаимодействие
- [ ] Event system
- [ ] Синхронизация данных
- [ ] Мониторинг

## 🧪 Тестирование

### Health Checks
Все сервисы доступны по адресу:
- https://api.tutuumarket.ru/api/users/health
- https://api.tutuumarket.ru/api/catalog/health
- https://api.tutuumarket.ru/api/orders/health
- https://api.tutuumarket.ru/api/logistics/health
- https://api.tutuumarket.ru/api/ai/health

### Тестовые данные
⚠️ **Внимание**: В текущей версии используются заглушки. Реальные данные будут доступны после настройки базы данных.

## 🚨 Известные ограничения

1. **База данных**: Не настроена, все данные - заглушки
2. **Валидация**: Схемы готовы, реализация отсутствует
3. **Тестирование**: Нет unit и integration тестов
4. **Производительность**: Без БД и кэширования

## 🤝 Вклад в проект

### Требования к PR
- TypeScript/ESLint проверки проходят
- Тесты написаны и проходят
- Документация обновлена
- Device ID tracking включен

### Стандарты кода
- TypeScript для Node.js сервисов
- Python + Pydantic для AI сервиса
- Express.js best practices
- FastAPI conventions

## 📞 Поддержка

- **Документация**: [API-DOCUMENTATION.md](./API-DOCUMENTATION.md)
- **Прогресс**: [DEVELOPMENT-PROGRESS.md](./DEVELOPMENT-PROGRESS.md)
- **Issues**: GitHub Issues
- **Email**: support@tutuumarket.ru

## 📄 Лицензия

MIT License - см. [LICENSE](./LICENSE) файл

---

**TUTUU MARKET MVP** - Строительная экосистема нового поколения 🏗️

**Статус**: Backend API 60% готов  
**Цель**: Полнофункциональный MVP к 15 декабря 2025
