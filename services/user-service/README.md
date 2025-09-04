# User Service - TUTUU MARKET MVP

**Версия**: 0.1.0  
**Статус**: Backend API готов, база данных интегрирована ✅  
**Последнее обновление**: 4 сентября 2025

## 🎯 Описание

User Service - это микросервис для управления пользователями, аутентификации и авторизации в экосистеме TUTUU MARKET. Сервис предоставляет полный функционал для работы с пользователями всех ролей (Customer, Seller, Carrier, Admin, Moderator).

## 🏗️ Архитектура

### Технологический стек
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: PostgreSQL + Prisma ORM
- **Authentication**: JWT (JSON Web Tokens)
- **Password Hashing**: bcrypt
- **Language**: TypeScript

### Структура базы данных
- **users** - основная таблица пользователей
- **user_profiles** - расширенные профили
- **user_sessions** - сессии и токены
- **user_verifications** - верификация email/phone
- **orders** - заказы (связь с order-service)
- **deliveries** - доставки (связь с logistics-service)

## 🚀 Быстрый старт

### Предварительные требования
- Node.js 18+
- PostgreSQL 15+ с PostGIS
- Docker (опционально)

### Установка зависимостей
```bash
npm install
```

### Настройка базы данных
```bash
# Автоматическая настройка
./setup-database.sh

# Или вручную
cp .env.example .env
# Отредактируйте .env файл с вашими настройками БД
```

### Генерация Prisma Client
```bash
npm run db:generate
```

### Применение миграций
```bash
# Для production
npm run db:migrate

# Для разработки (сброс данных)
npm run db:reset
```

### Заполнение тестовыми данными
```bash
npm run db:seed
```

### Запуск сервиса
```bash
# Режим разработки
npm run dev

# Production
npm run build
npm start
```

## 📊 Модели данных

### User (Пользователь)
```typescript
interface User {
  id: string;
  email: string;
  phone?: string;
  passwordHash: string;
  role: UserRole;
  isActive: boolean;
  isVerified: boolean;
  emailVerified: boolean;
  phoneVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
  lastLoginAt?: Date;
}
```

### UserProfile (Профиль пользователя)
```typescript
interface UserProfile {
  id: string;
  userId: string;
  firstName?: string;
  lastName?: string;
  middleName?: string;
  birthDate?: Date;
  gender?: Gender;
  avatar?: string;
  bio?: string;
  companyName?: string;
  companyPosition?: string;
  companyAddress?: string;
  companyPhone?: string;
  companyWebsite?: string;
  taxId?: string;
  bankAccount?: string;
  preferences?: Json;
}
```

### UserSession (Сессия пользователя)
```typescript
interface UserSession {
  id: string;
  userId: string;
  deviceId: string;
  deviceType: DeviceType;
  deviceInfo?: Json;
  ipAddress?: string;
  userAgent?: string;
  refreshToken: string;
  accessToken: string;
  expiresAt: Date;
  isActive: boolean;
}
```

## 🔐 Аутентификация и авторизация

### Роли пользователей
- **CUSTOMER** - Покупатель (создание заказов, просмотр каталога)
- **SELLER** - Продавец (управление товарами, складами)
- **CARRIER** - Перевозчик (доставка заказов)
- **ADMIN** - Администратор (полный доступ)
- **MODERATOR** - Модератор (модерация контента)

### JWT токены
- **Access Token**: короткий срок действия (15 минут)
- **Refresh Token**: длительный срок действия (7 дней)
- **Device ID**: отслеживание устройств

### Безопасность
- Хеширование паролей с bcrypt (12 раундов)
- Валидация входных данных
- Rate limiting для API endpoints
- CORS настройки

## 📡 API Endpoints

### Аутентификация
- `POST /auth/register` - Регистрация пользователя
- `POST /auth/login` - Вход в систему
- `POST /auth/refresh` - Обновление токена
- `POST /auth/logout` - Выход из системы
- `POST /auth/verify-email` - Верификация email
- `POST /auth/verify-phone` - Верификация телефона
- `POST /auth/forgot-password` - Восстановление пароля
- `POST /auth/reset-password` - Сброс пароля

### Пользователи
- `GET /users/profile` - Получение профиля
- `PUT /users/profile` - Обновление профиля
- `GET /users/sessions` - Получение активных сессий
- `DELETE /users/sessions/:id` - Завершение сессии
- `GET /users/verifications` - Получение верификаций

### Администрация
- `GET /admin/users` - Список всех пользователей
- `PUT /admin/users/:id/status` - Изменение статуса пользователя
- `GET /admin/users/:id/sessions` - Сессии пользователя
- `DELETE /admin/users/:id` - Удаление пользователя

## 🗄️ Управление базой данных

### Prisma команды
```bash
# Генерация клиента
npx prisma generate

# Создание миграции
npx prisma migrate dev --name migration_name

# Применение миграций в production
npx prisma migrate deploy

# Сброс базы данных (только для разработки)
npx prisma migrate reset

# Открытие Prisma Studio
npx prisma studio

# Просмотр схемы
npx prisma format
```

### Миграции
Все миграции хранятся в папке `prisma/migrations/`. Каждая миграция содержит:
- SQL файл с изменениями
- README с описанием изменений
- Версию и дату создания

### Seed данные
Файл `prisma/seed.ts` содержит тестовые данные:
- 5 пользователей разных ролей
- Тестовые сессии
- Тестовые заказы и доставки

## 🔧 Конфигурация

### Переменные окружения (.env)
```env
# База данных
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/tutuu_users"

# JWT
JWT_SECRET="your-super-secret-jwt-key"
JWT_EXPIRES_IN="15m"
REFRESH_TOKEN_EXPIRES_IN="7d"

# Безопасность
PASSWORD_SALT_ROUNDS=12

# Redis
REDIS_URL="redis://localhost:6379"

# Сервис
PORT=3001
HOST=0.0.0.0
NODE_ENV=development

# Логирование
LOG_LEVEL=info
```

### Docker
```bash
# Сборка образа
docker build -t tutuu-user-service .

# Запуск контейнера
docker run -p 3001:3001 \
  -e DATABASE_URL="postgresql://postgres:postgres@host.docker.internal:5432/tutuu_users" \
  tutuu-user-service
```

## 🧪 Тестирование

### Тестовые данные
После запуска seed скрипта доступны тестовые пользователи:
- **admin@tutuumarket.ru** / password123 (ADMIN)
- **seller@example.ru** / password123 (SELLER)
- **customer@example.ru** / password123 (CUSTOMER)
- **carrier@example.ru** / password123 (CARRIER)
- **moderator@tutuumarket.ru** / password123 (MODERATOR)

### Тестирование API
```bash
# Проверка здоровья сервиса
curl http://localhost:3001/health

# Регистрация пользователя
curl -X POST http://localhost:3001/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.ru","password":"password123","role":"CUSTOMER"}'

# Вход в систему
curl -X POST http://localhost:3001/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.ru","password":"password123"}'
```

## 📈 Мониторинг и логирование

### Логирование
- Структурированные логи в JSON формате
- Уровни: error, warn, info, debug
- Device ID tracking для всех запросов
- Временные метки для всех событий

### Метрики
- Время ответа API
- Количество активных пользователей
- Статистика аутентификации
- Ошибки и исключения

## 🚀 Развертывание

### Production
```bash
# Сборка
npm run build

# Применение миграций
npm run db:migrate

# Запуск
npm start
```

### Docker Compose
```yaml
user-service:
  build: ./services/user-service
  ports:
    - "3001:3001"
  environment:
    - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/tutuu_users
  depends_on:
    - postgres
    - redis
```

## 🔗 Интеграции

### Внутренние сервисы
- **Order Service** - заказы пользователей
- **Logistics Service** - доставки и трекинг
- **Catalog Service** - каталог товаров

### Внешние сервисы
- **Email Service** - отправка уведомлений
- **SMS Service** - SMS верификация
- **Payment Service** - обработка платежей

## 📚 Документация

### Swagger/OpenAPI
- Автоматическая генерация документации
- Доступна по адресу `/docs`
- Интерактивное тестирование API

### Prisma Studio
- Визуальный интерфейс для базы данных
- Доступен по команде `npm run db:studio`
- Просмотр и редактирование данных

## 🐛 Устранение неполадок

### Частые проблемы

#### Ошибка подключения к базе данных
```bash
Error: P1001: Can't reach database server
```
**Решение**: Проверьте, что PostgreSQL запущен и доступен по указанному адресу.

#### Ошибка Prisma Client
```bash
Error: PrismaClient is not generated
```
**Решение**: Выполните `npm run db:generate`

#### Ошибка миграции
```bash
Error: Migration failed
```
**Решение**: Проверьте логи и убедитесь, что схема БД соответствует миграции.

### Логи
```bash
# Просмотр логов сервиса
npm run dev

# Просмотр логов базы данных
docker logs tutuu_postgres

# Просмотр логов Redis
docker logs tutuu_redis
```

## 📞 Поддержка

### Команда разработки
- **CTO**: Cursor AI
- **Lead Developer**: TBD
- **DevOps Engineer**: TBD

### Ресурсы
- [Prisma Documentation](https://www.prisma.io/docs)
- [Express.js Documentation](https://expressjs.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [JWT.io](https://jwt.io/)

---

**Последнее обновление**: 4 сентября 2025  
**Версия**: 0.1.0  
**Статус**: Backend API готов, база данных интегрирована ✅
