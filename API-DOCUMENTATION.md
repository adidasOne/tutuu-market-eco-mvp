# TUTUU MARKET MVP API Documentation

## Обзор

TUTUU MARKET MVP состоит из 5 микросервисов, каждый из которых предоставляет RESTful API для определенной области функциональности.

## Базовые принципы

### Device ID Tracking
Все API endpoints требуют заголовок `x-device-id` для отслеживания устройств пользователей.

### Аутентификация
Большинство endpoints требуют JWT токен в заголовке `Authorization: Bearer <token>`.

### Формат ответов
Все ответы имеют единый формат:
```json
{
  "success": true/false,
  "message": "Описание результата",
  "deviceId": "device-identifier",
  "data": { ... }
}
```

## Микросервисы

### 1. User Service (Port 3001)

**Базовый URL**: `https://api.tutuumarket.ru/api/users/`

#### Endpoints

##### Регистрация пользователя
```
POST /register
```
**Тело запроса:**
```json
{
  "email": "user@example.com",
  "phone": "+79001234567",
  "firstName": "Иван",
  "lastName": "Иванов",
  "password": "securePassword123",
  "role": "customer"
}
```

##### Аутентификация
```
POST /login
```
**Тело запроса:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

##### Получение профиля
```
GET /profile
```
**Заголовки:** `Authorization: Bearer <token>`

##### Обновление профиля
```
PUT /profile
```
**Заголовки:** `Authorization: Bearer <token>`
**Тело запроса:**
```json
{
  "firstName": "Новое имя",
  "phone": "+79001234567"
}
```

##### Список пользователей (Admin)
```
GET /
```
**Заголовки:** `Authorization: Bearer <token>`, `role: admin`

### 2. Catalog Service (Port 3002)

**Базовый URL**: `https://api.tutuumarket.ru/api/catalog/`

#### Endpoints

##### Поиск товаров
```
GET /products/search?query=кирпич&minPrice=100&maxPrice=1000&page=1&limit=20
```

##### Получение товара по ID
```
GET /products/{id}
```

##### Создание товара (Seller)
```
POST /products
```
**Заголовки:** `Authorization: Bearer <token>`, `role: seller`
**Тело запроса:**
```json
{
  "name": "Кирпич красный",
  "description": "Керамический кирпич для строительства",
  "price": 15.50,
  "currency": "RUB",
  "categoryId": "bricks",
  "images": ["image1.jpg", "image2.jpg"],
  "characteristics": [
    {
      "name": "Размер",
      "value": "250x120x65",
      "unit": "мм"
    }
  ],
  "stock": [
    {
      "warehouseId": "warehouse-1",
      "quantity": 10000,
      "location": {
        "latitude": 55.7558,
        "longitude": 37.6176,
        "address": "Москва, ул. Примерная, 1"
      }
    }
  ]
}
```

##### Категории товаров
```
GET /categories
GET /categories/{id}
```

##### Склады
```
GET /warehouses?sellerId={sellerId}
POST /warehouses
```

### 3. Order Service (Port 3003)

**Базовый URL**: `https://api.tutuumarket.ru/api/orders/`

#### Endpoints

##### Корзина
```
GET /cart?customerId={customerId}
POST /cart/items
PUT /cart/items/{itemId}
DELETE /cart/items/{itemId}
DELETE /cart?customerId={customerId}
```

##### Заказы
```
POST /orders/from-cart
POST /orders
GET /orders/{id}
PUT /orders/{id}
POST /orders/{id}/cancel
GET /orders
```

**Создание заказа из корзины:**
```json
{
  "deliveryAddress": {
    "street": "ул. Доставки",
    "house": "15",
    "apartment": "42",
    "city": "Москва",
    "region": "Московская область",
    "postalCode": "123456",
    "country": "Россия"
  },
  "deliveryMethod": "delivery",
  "paymentMethod": "card",
  "notes": "Доставить до 18:00"
}
```

### 4. Logistics Service (Port 3004)

**Базовый URL**: `https://api.tutuumarket.ru/api/logistics/`

#### Endpoints

##### Доставки
```
POST /deliveries
GET /deliveries/{id}
PUT /deliveries/{id}
POST /deliveries/{id}/assign-carrier
POST /deliveries/{id}/cancel
GET /deliveries
```

##### Перевозчики
```
GET /carriers
GET /carriers/{id}
POST /carriers
PUT /carriers/{id}
```

##### Трекинг
```
GET /deliveries/{id}/tracking
POST /deliveries/{id}/location
```

**Создание заявки на доставку:**
```json
{
  "orderId": "order-123",
  "pickupAddress": {
    "street": "ул. Склада",
    "house": "1",
    "city": "Москва",
    "region": "Московская область",
    "postalCode": "123456",
    "country": "Россия",
    "coordinates": {
      "latitude": 55.7558,
      "longitude": 37.6176
    }
  },
  "deliveryAddress": {
    "street": "ул. Доставки",
    "house": "15",
    "city": "Москва",
    "region": "Московская область",
    "postalCode": "123456",
    "country": "Россия",
    "coordinates": {
      "latitude": 55.7600,
      "longitude": 37.6200
    }
  },
  "items": [
    {
      "productName": "Кирпич красный",
      "quantity": 1000,
      "weight": 3500,
      "volume": 2.5,
      "isFragile": false,
      "requiresSpecialHandling": false
    }
  ],
  "specialRequirements": ["Доставка до 18:00"]
}
```

### 5. AI Service (Port 3005)

**Базовый URL**: `https://api.tutuumarket.ru/api/ai/`

#### Endpoints

##### Рекомендации товаров
```
POST /recommendations
```
**Тело запроса:**
```json
{
  "user_id": "user-123",
  "search_query": "кирпич",
  "category": "building_materials",
  "budget": 50000,
  "location": {
    "latitude": 55.7558,
    "longitude": 37.6176,
    "radius": 50
  }
}
```

##### Прогноз цен
```
POST /price-prediction
```
**Тело запроса:**
```json
{
  "product_id": "product-123",
  "market_data": {
    "demand": "high",
    "supply": "stable",
    "season": "summer"
  },
  "historical_prices": [100, 105, 110, 108, 115]
}
```

##### Смета строительства
```
POST /construction-estimate
```
**Тело запроса:**
```json
{
  "project_type": "house",
  "area": 150.0,
  "materials": ["кирпич", "цемент", "доски"],
  "complexity": "medium"
}
```

##### Анализ рынка
```
GET /market-analysis
```

## Коды ошибок

### HTTP Status Codes
- `200` - Успешный запрос
- `201` - Создано
- `400` - Неверный запрос
- `401` - Не авторизован
- `403` - Доступ запрещен
- `404` - Не найдено
- `500` - Внутренняя ошибка сервера

### Примеры ошибок
```json
{
  "success": false,
  "message": "Токен доступа не предоставлен",
  "deviceId": "device-123"
}
```

## Аутентификация

### JWT Token
JWT токены содержат следующую информацию:
```json
{
  "id": "user-id",
  "email": "user@example.com",
  "role": "customer",
  "deviceId": "device-123",
  "iat": 1634567890,
  "exp": 1634654290
}
```

### Получение токена
1. Зарегистрируйтесь: `POST /api/users/register`
2. Войдите в систему: `POST /api/users/login`
3. Используйте полученный токен в заголовке `Authorization: Bearer <token>`

## Тестирование API

### Health Checks
Все сервисы предоставляют health check endpoints:
- `GET /api/users/health`
- `GET /api/catalog/health`
- `GET /api/orders/health`
- `GET /api/logistics/health`
- `GET /api/ai/health`

### Примеры запросов

#### cURL
```bash
# Регистрация пользователя
curl -X POST https://api.tutuumarket.ru/api/users/register \
  -H "Content-Type: application/json" \
  -H "x-device-id: device-123" \
  -d '{
    "email": "test@example.com",
    "phone": "+79001234567",
    "firstName": "Тест",
    "lastName": "Пользователь",
    "password": "password123",
    "role": "customer"
  }'

# Поиск товаров
curl -X GET "https://api.tutuumarket.ru/api/catalog/products/search?query=кирпич&page=1&limit=10" \
  -H "x-device-id: device-123"
```

#### JavaScript (Fetch)
```javascript
// Поиск товаров
const response = await fetch(
  'https://api.tutuumarket.ru/api/catalog/products/search?query=кирпич',
  {
    headers: {
      'x-device-id': 'device-123'
    }
  }
);

const data = await response.json();
console.log(data);
```

## Разработка

### Локальная разработка
```bash
# Клонирование репозитория
git clone <repository-url>
cd tutuu-market-eco-mvp

# Установка зависимостей
cd services/user-service && npm install
cd ../catalog-service && npm install
cd ../order-service && npm install
cd ../logistics-service && npm install
cd ../ai-service && pip install -r requirements.txt

# Запуск сервисов
docker-compose up -d
```

### Переменные окружения
Создайте `.env` файл в корне проекта:
```env
JWT_SECRET=your-secret-key
DATABASE_URL=postgresql://user:password@localhost:5432/tutuu_market
REDIS_URL=redis://localhost:6379
```

## Поддержка

Для получения поддержки по API:
- Email: support@tutuumarket.ru
- Документация: https://docs.tutuumarket.ru
- GitHub Issues: https://github.com/tutuu-market/issues

---

**Версия документации**: 1.0.0  
**Последнее обновление**: 3 сентября 2025  
**Статус**: MVP Development
