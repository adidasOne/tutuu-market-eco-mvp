# Миграция: Инициализация User Service

**Дата**: 4 сентября 2025  
**Версия**: 1.0.0  
**Описание**: Создание базовой структуры базы данных для User Service

## 📊 Создаваемые таблицы

### 1. `users` - Основная таблица пользователей
- Основная информация: email, phone, passwordHash, role
- Статусы: isActive, isVerified, emailVerified, phoneVerified
- Временные метки: createdAt, updatedAt, lastLoginAt

### 2. `user_profiles` - Расширенные профили
- Личная информация: firstName, lastName, middleName, birthDate, gender
- Компания: companyName, companyPosition, companyAddress, companyPhone, companyWebsite
- Финансы: taxId, bankAccount
- Настройки: preferences (JSON)

### 3. `user_sessions` - Сессии пользователей
- Устройство: deviceId, deviceType, deviceInfo, ipAddress, userAgent
- Токены: refreshToken, accessToken, expiresAt
- Статус: isActive

### 4. `user_verifications` - Верификация
- Тип: EMAIL, PHONE, PASSWORD_RESET, TWO_FACTOR
- Код: code, expiresAt, attempts, maxAttempts
- Статус: isUsed

### 5. `orders` - Заказы (связь с order-service)
- Основная информация: orderNumber, status, totalAmount, currency
- Связи: userId

### 6. `deliveries` - Доставки (связь с logistics-service)
- Статус доставки: status, carrierId
- Временные метки: estimatedDelivery, actualDelivery
- Связи: userId, orderId

## 🔧 Enums

### UserRole
- `CUSTOMER` - Покупатель
- `SELLER` - Продавец
- `CARRIER` - Перевозчик
- `ADMIN` - Администратор
- `MODERATOR` - Модератор

### Gender
- `MALE` - Мужской
- `FEMALE` - Женский
- `OTHER` - Другой
- `PREFER_NOT_TO_SAY` - Предпочитаю не указывать

### DeviceType
- `MOBILE` - Мобильное устройство
- `TABLET` - Планшет
- `DESKTOP` - Десктоп
- `WEB` - Веб-браузер

### VerificationType
- `EMAIL` - Верификация email
- `PHONE` - Верификация телефона
- `PASSWORD_RESET` - Сброс пароля
- `TWO_FACTOR` - Двухфакторная аутентификация

### OrderStatus
- `PENDING` - Ожидает подтверждения
- `CONFIRMED` - Подтвержден
- `PROCESSING` - В обработке
- `SHIPPED` - Отправлен
- `DELIVERED` - Доставлен
- `CANCELLED` - Отменен
- `REFUNDED` - Возвращен

### DeliveryStatus
- `PENDING` - Ожидает назначения
- `ASSIGNED` - Назначен перевозчик
- `IN_TRANSIT` - В пути
- `DELIVERED` - Доставлен
- `FAILED` - Ошибка доставки
- `CANCELLED` - Отменен

## 🔗 Связи между таблицами

- `users` → `user_profiles` (1:1)
- `users` → `user_sessions` (1:N)
- `users` → `user_verifications` (1:N)
- `users` → `orders` (1:N)
- `users` → `deliveries` (1:N)

## 📝 Применение миграции

### Локальная разработка
```bash
npx prisma migrate dev
```

### Production
```bash
npx prisma migrate deploy
```

### Откат (если необходимо)
```bash
npx prisma migrate reset
```

## 🚀 Следующие шаги

1. **Seed данные** - создание тестовых пользователей
2. **Индексы** - оптимизация запросов
3. **Валидация** - проверка целостности данных
4. **Тестирование** - проверка всех CRUD операций
