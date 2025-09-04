# План интеграции базы данных PostgreSQL - TUTUU MARKET MVP

**Дата создания**: 4 сентября 2025  
**Статус**: Планирование  
**Приоритет**: Высокий  
**Ответственный**: CTO (Cursor AI)

## 🎯 Цель интеграции

Реализовать полнофункциональную базу данных PostgreSQL с PostGIS для MVP, включая схемы, миграции, Prisma ORM и seed данные.

## 📊 Текущее состояние

### ✅ Что уже готово
- **PostgreSQL контейнер** развернут и работает
- **PostGIS расширение** установлено
- **Redis** для кэширования
- **Схемы БД** спроектированы в документации
- **API endpoints** готовы для интеграции

### ❌ Что требует реализации
- **Схемы таблиц** в PostgreSQL
- **Prisma ORM** интеграция
- **Миграции** базы данных
- **Seed данные** для разработки
- **Индексы** и оптимизация

## 🏗️ Архитектура базы данных

### Основные сущности MVP

#### 1. Пользователи и аутентификация
```sql
-- users (основная таблица пользователей)
-- user_profiles (расширенные профили)
-- user_sessions (сессии и токены)
-- user_verifications (верификация)
```

#### 2. Складская система
```sql
-- warehouses (склады продавцов)
-- warehouse_products (остатки по складам)
-- warehouse_locations (геолокация складов)
```

#### 3. Логистическая система
```sql
-- carriers (перевозчики)
-- vehicles (транспортные средства)
-- deliveries (заказы на доставку)
-- delivery_tracking (трекинг доставок)
```

#### 4. Каталог товаров
```sql
-- products (товары)
-- categories (категории)
-- product_attributes (характеристики)
-- product_images (изображения)
```

#### 5. Заказы и сметы
```sql
-- orders (заказы)
-- order_items (позиции заказов)
-- estimates (сметы)
-- estimate_items (позиции смет)
```

## 🔧 Техническая реализация

### Этап 1: Настройка Prisma ORM (1-2 дня)

#### 1.1 Установка зависимостей
```bash
# В каждом сервисе
npm install prisma @prisma/client
npm install -D prisma
```

#### 1.2 Инициализация Prisma
```bash
npx prisma init
```

#### 1.3 Конфигурация подключения
```env
# .env
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/tutuu_market?schema=public"
```

### Этап 2: Создание схемы Prisma (2-3 дня)

#### 2.1 Основные модели
```prisma
// schema.prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  phone     String?  @unique
  firstName String
  lastName  String
  role      UserRole
  status    UserStatus @default(ACTIVE)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Relations
  profile   UserProfile?
  orders    Order[]
  deliveries Delivery[]
  
  @@map("users")
}

model Warehouse {
  id        String   @id @default(cuid())
  name      String
  address   String
  coordinates Json? // PostGIS coordinates
  type      WarehouseType
  sellerId  String
  isActive  Boolean  @default(true)
  
  // Relations
  seller    User     @relation(fields: [sellerId], references: [id])
  products  WarehouseProduct[]
  
  @@map("warehouses")
}
```

#### 2.2 Геопространственные данные
```prisma
// Расширение для PostGIS
model WarehouseLocation {
  id          String   @id @default(cuid())
  warehouseId String   @unique
  latitude    Float
  longitude   Float
  address     String
  
  // PostGIS функции
  @@map("warehouse_locations")
}
```

### Этап 3: Миграции и seed данные (1-2 дня)

#### 3.1 Создание миграций
```bash
npx prisma migrate dev --name init
```

#### 3.2 Seed данные
```typescript
// prisma/seed.ts
async function main() {
  // Создание тестовых пользователей
  const admin = await prisma.user.create({
    data: {
      email: 'admin@tutuumarket.ru',
      firstName: 'Администратор',
      lastName: 'Системы',
      role: 'ADMIN',
      phone: '+79001234567'
    }
  });
  
  // Создание тестовых категорий
  const categories = await Promise.all([
    prisma.category.create({
      data: { name: 'Кирпич и блоки', slug: 'kirpich-bloki' }
    }),
    prisma.category.create({
      data: { name: 'Цемент и смеси', slug: 'cement-smesi' }
    })
  ]);
}
```

## 📅 План реализации

### Неделя 1 (4-10 сентября 2025)
- [ ] **День 1-2**: Настройка Prisma ORM во всех сервисах
- [ ] **День 3-4**: Создание схемы Prisma для основных сущностей
- [ ] **День 5**: Создание миграций и seed данных

### Неделя 2 (11-17 сентября 2025)
- [ ] **День 1-2**: Интеграция Prisma в API endpoints
- [ ] **День 3-4**: Тестирование и отладка
- [ ] **День 5**: Оптимизация и индексы

## 🚀 Следующие шаги после интеграции БД

### 1. Бизнес-логика (2-3 недели)
- Валидация данных
- Бизнес-правила
- Интеграция между сервисами

### 2. Frontend разработка (4-6 недель)
- React Native проект
- Интеграция с API
- UI/UX компоненты

### 3. Тестирование (2-3 недели)
- Unit тесты
- Integration тесты
- E2E тесты

## 🔍 Критерии успеха

### Функциональные
- [ ] Все CRUD операции работают
- [ ] Геопространственные запросы выполняются
- [ ] Связи между сущностями корректны
- [ ] Seed данные загружены

### Технические
- [ ] Prisma ORM интегрирован
- [ ] Миграции выполняются без ошибок
- [ ] Производительность запросов < 100ms
- [ ] Индексы оптимизированы

### Качество
- [ ] Схема БД соответствует требованиям
- [ ] Документация обновлена
- [ ] Тесты покрывают основные сценарии
- [ ] Код соответствует стандартам

## 📚 Ресурсы и документация

### Полезные ссылки
- [Prisma Documentation](https://www.prisma.io/docs/)
- [PostGIS Documentation](https://postgis.net/documentation/)
- [PostgreSQL Best Practices](https://www.postgresql.org/docs/current/)

### Внутренние документы
- [API Specification](API-DOCUMENTATION.md)
- [Database Schema](database-schema.md)
- [Technical Architecture](technical-architecture.md)

---

**Последнее обновление**: 4 сентября 2025  
**Следующее обновление**: 11 сентября 2025
