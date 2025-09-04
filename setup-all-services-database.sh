#!/bin/bash

echo "🚀 Настройка базы данных для всех сервисов TUTUU MARKET MVP..."
echo "📅 Дата: $(date)"
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для логирования
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Проверка наличия Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_warning "Docker не установлен. Проверяем локальные сервисы..."
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        log_warning "Docker не запущен. Проверяем локальные сервисы..."
        return 1
    fi
    
    log_success "Docker доступен"
    return 0
}

# Настройка User Service
setup_user_service() {
    log_info "Настройка User Service..."
    cd services/user-service
    
    if [ -f "setup-database.sh" ]; then
        log_info "Запуск автоматической настройки User Service..."
        chmod +x setup-database.sh
        ./setup-database.sh
        log_success "User Service настроен"
    else
        log_warning "setup-database.sh не найден в User Service"
    fi
    
    cd ../..
}

# Настройка Catalog Service
setup_catalog_service() {
    log_info "Настройка Catalog Service..."
    cd services/catalog-service
    
    # Проверяем, есть ли уже Prisma
    if [ ! -d "prisma" ]; then
        log_info "Инициализация Prisma для Catalog Service..."
        npm install prisma @prisma/client
        npm install -D prisma
        npx prisma init
        
        # Создаем схему для catalog-service
        cat > prisma/schema.prisma << 'EOF'
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
  output   = "../src/generated/prisma"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Категории товаров
model Category {
  id          String   @id @default(cuid())
  name        String
  description String?
  parentId    String?
  isActive    Boolean  @default(true)
  sortOrder   Int      @default(0)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Отношения
  parent      Category?  @relation("CategoryHierarchy", fields: [parentId], references: [id])
  children    Category[] @relation("CategoryHierarchy")
  products    Product[]
  
  @@map("categories")
}

// Товары
model Product {
  id          String   @id @default(cuid())
  name        String
  description String?
  sku         String   @unique
  barcode     String?
  categoryId  String
  brand       String?
  model       String?
  weight      Decimal? @db.Decimal(10, 3)
  dimensions  Json?    // {length, width, height}
  isActive    Boolean  @default(true)
  isFeatured  Boolean  @default(false)
  sortOrder   Int      @default(0)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Отношения
  category    Category           @relation(fields: [categoryId], references: [id])
  attributes  ProductAttribute[]
  images      ProductImage[]
  warehouses  WarehouseProduct[]
  
  @@map("products")
}

// Характеристики товаров
model ProductAttribute {
  id        String   @id @default(cuid())
  productId String
  name      String
  value     String
  unit      String?
  sortOrder Int      @default(0)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Отношения
  product   Product @relation(fields: [productId], references: [id], onDelete: Cascade)
  
  @@map("product_attributes")
}

// Изображения товаров
model ProductImage {
  id        String   @id @default(cuid())
  productId String
  url       String
  alt       String?
  isPrimary Boolean  @default(false)
  sortOrder Int      @default(0)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Отношения
  product   Product @relation(fields: [productId], references: [id], onDelete: Cascade)
  
  @@map("product_images")
}

// Склады
model Warehouse {
  id          String   @id @default(cuid())
  name        String
  description String?
  address     String
  city        String
  region      String
  country     String   @default("Россия")
  postalCode  String?
  phone       String?
  email       String?
  isActive    Boolean  @default(true)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Отношения
  products   WarehouseProduct[]
  location   WarehouseLocation?
  
  @@map("warehouses")
}

// Геолокация складов
model WarehouseLocation {
  id          String   @id @default(cuid())
  warehouseId String   @unique
  latitude    Decimal  @db.Decimal(10, 8)
  longitude   Decimal  @db.Decimal(11, 8)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Отношения
  warehouse  Warehouse @relation(fields: [warehouseId], references: [id], onDelete: Cascade)
  
  @@map("warehouse_locations")
}

// Остатки товаров по складам
model WarehouseProduct {
  id          String   @id @default(cuid())
  warehouseId String
  productId   String
  quantity    Int      @default(0)
  reserved    Int      @default(0)
  available   Int      @default(0)
  minStock    Int      @default(0)
  maxStock    Int?
  unitPrice   Decimal  @db.Decimal(10, 2)
  currency    String   @default("RUB")
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Отношения
  warehouse  Warehouse @relation(fields: [warehouseId], references: [id], onDelete: Cascade)
  product    Product   @relation(fields: [productId], references: [id], onDelete: Cascade)
  
  @@unique([warehouseId, productId])
  @@map("warehouse_products")
}
EOF
        
        # Создаем .env файл
        cat > .env << 'EOF'
# Environment variables for Catalog Service
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/tutuu_catalog"
PORT=3002
HOST=0.0.0.0
LOG_LEVEL=info
EOF
        
        log_success "Prisma инициализирован для Catalog Service"
    else
        log_info "Prisma уже настроен для Catalog Service"
    fi
    
    cd ../..
}

# Настройка Order Service
setup_order_service() {
    log_info "Настройка Order Service..."
    cd services/order-service
    
    # Проверяем, есть ли уже Prisma
    if [ ! -d "prisma" ]; then
        log_info "Инициализация Prisma для Order Service..."
        npm install prisma @prisma/client
        npm install -D prisma
        npx prisma init
        
        # Создаем схему для order-service
        cat > prisma/schema.prisma << 'EOF'
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
  output   = "../src/generated/prisma"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Заказы
model Order {
  id              String      @id @default(cuid())
  orderNumber     String      @unique
  userId          String
  status          OrderStatus @default(PENDING)
  totalAmount     Decimal     @db.Decimal(10, 2)
  currency        String      @default("RUB")
  paymentStatus   PaymentStatus @default(PENDING)
  paymentMethod   PaymentMethod?
  shippingAddress Json        // Адрес доставки
  billingAddress  Json?       // Адрес для счета
  notes           String?
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt
  
  // Отношения
  items          OrderItem[]
  payments       Payment[]
  deliveries     Delivery[]
  
  @@map("orders")
}

// Позиции заказов
model OrderItem {
  id        String   @id @default(cuid())
  orderId   String
  productId String
  quantity  Int
  unitPrice Decimal @db.Decimal(10, 2)
  totalPrice Decimal @db.Decimal(10, 2)
  discount  Decimal @db.Decimal(10, 2) @default(0)
  notes     String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Отношения
  order     Order    @relation(fields: [orderId], references: [id], onDelete: Cascade)
  
  @@map("order_items")
}

// Платежи
model Payment {
  id            String        @id @default(cuid())
  orderId       String
  amount        Decimal       @db.Decimal(10, 2)
  currency      String        @default("RUB")
  method        PaymentMethod
  status        PaymentStatus @default(PENDING)
  transactionId String?
  gateway       String?
  gatewayData   Json?
  createdAt     DateTime      @default(now())
  updatedAt     DateTime      @updatedAt
  
  // Отношения
  order         Order         @relation(fields: [orderId], references: [id], onDelete: Cascade)
  
  @@map("payments")
}

// Доставки
model Delivery {
  id                String         @id @default(cuid())
  orderId           String
  carrierId         String?
  status            DeliveryStatus @default(PENDING)
  trackingNumber    String?
  estimatedDelivery DateTime?
  actualDelivery    DateTime?
  shippingCost      Decimal        @db.Decimal(10, 2) @default(0)
  notes             String?
  createdAt         DateTime       @default(now())
  updatedAt         DateTime       @updatedAt
  
  // Отношения
  order             Order          @relation(fields: [orderId], references: [id], onDelete: Cascade)
  
  @@map("deliveries")
}

// Корзина покупок
model Cart {
  id        String   @id @default(cuid())
  userId    String   @unique
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Отношения
  items     CartItem[]
  
  @@map("carts")
}

// Позиции корзины
model CartItem {
  id        String   @id @default(cuid())
  cartId    String
  productId String
  quantity  Int
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Отношения
  cart      Cart     @relation(fields: [cartId], references: [id], onDelete: Cascade)
  
  @@unique([cartId, productId])
  @@map("cart_items")
}

// Enums
enum OrderStatus {
  PENDING
  CONFIRMED
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
  REFUNDED
}

enum PaymentStatus {
  PENDING
  PROCESSING
  COMPLETED
  FAILED
  CANCELLED
  REFUNDED
}

enum PaymentMethod {
  CARD
  CASH
  BANK_TRANSFER
  ELECTRONIC_WALLET
}

enum DeliveryStatus {
  PENDING
  ASSIGNED
  IN_TRANSIT
  DELIVERED
  FAILED
  CANCELLED
}
EOF
        
        # Создаем .env файл
        cat > .env << 'EOF'
# Environment variables for Order Service
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/tutuu_orders"
PORT=3003
HOST=0.0.0.0
LOG_LEVEL=info
EOF
        
        log_success "Prisma инициализирован для Order Service"
    else
        log_info "Prisma уже настроен для Order Service"
    fi
    
    cd ../..
}

# Настройка Logistics Service
setup_logistics_service() {
    log_info "Настройка Logistics Service..."
    cd services/logistics-service
    
    # Проверяем, есть ли уже Prisma
    if [ ! -d "prisma" ]; then
        log_info "Инициализация Prisma для Logistics Service..."
        npm install prisma @prisma/client
        npm install -D prisma
        npx prisma init
        
        # Создаем схему для logistics-service
        cat > prisma/schema.prisma << 'EOF'
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
  output   = "../src/generated/prisma"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Перевозчики
model Carrier {
  id            String        @id @default(cuid())
  userId        String        @unique
  companyName   String?
  taxId         String?
  licenseNumber String?
  isActive      Boolean       @default(true)
  isVerified    Boolean       @default(false)
  rating        Decimal       @db.Decimal(3, 2) @default(0)
  totalDeliveries Int         @default(0)
  successfulDeliveries Int     @default(0)
  createdAt     DateTime      @default(now())
  updatedAt     DateTime      @updatedAt
  
  // Отношения
  vehicles     Vehicle[]
  deliveries   Delivery[]
  
  @@map("carriers")
}

// Транспортные средства
model Vehicle {
  id            String        @id @default(cuid())
  carrierId     String
  type          VehicleType
  model         String
  licensePlate  String        @unique
  capacity      Decimal       @db.Decimal(10, 2) // в тоннах
  dimensions    Json?         // {length, width, height}
  isAvailable   Boolean       @default(true)
  isActive      Boolean       @default(true)
  createdAt     DateTime      @default(now())
  updatedAt     DateTime      @updatedAt
  
  // Отношения
  carrier       Carrier       @relation(fields: [carrierId], references: [id], onDelete: Cascade)
  
  @@map("vehicles")
}

// Доставки
model Delivery {
  id                String         @id @default(cuid())
  orderId           String
  carrierId         String?
  status            DeliveryStatus @default(PENDING)
  pickupAddress     Json           // Адрес забора
  deliveryAddress   Json           // Адрес доставки
  pickupDate        DateTime?
  deliveryDate      DateTime?
  estimatedDuration Int?           // в минутах
  actualDuration    Int?
  distance          Decimal?       @db.Decimal(10, 2) // в километрах
  cost              Decimal        @db.Decimal(10, 2)
  currency          String         @default("RUB")
  trackingNumber    String?
  notes             String?
  createdAt         DateTime       @default(now())
  updatedAt         DateTime       @updatedAt
  
  // Отношения
  carrier           Carrier?       @relation(fields: [carrierId], references: [id])
  tracking          DeliveryTracking[]
  
  @@map("deliveries")
}

// Трекинг доставок
model DeliveryTracking {
  id          String   @id @default(cuid())
  deliveryId  String
  status      DeliveryStatus
  location    Json?    // {latitude, longitude, address}
  timestamp   DateTime @default(now())
  notes       String?
  
  // Отношения
  delivery    Delivery @relation(fields: [deliveryId], references: [id], onDelete: Cascade)
  
  @@map("delivery_tracking")
}

// Предложения перевозчиков
model CarrierOffer {
  id          String   @id @default(cuid())
  deliveryId  String
  carrierId   String
  price       Decimal  @db.Decimal(10, 2)
  currency    String   @default("RUB")
  estimatedDelivery DateTime
  notes       String?
  isAccepted  Boolean  @default(false)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Отношения
  delivery    Delivery @relation(fields: [deliveryId], references: [id], onDelete: Cascade)
  carrier     Carrier  @relation(fields: [carrierId], references: [id], onDelete: Cascade)
  
  @@unique([deliveryId, carrierId])
  @@map("carrier_offers")
}

// Enums
enum VehicleType {
  TRUCK
  VAN
  PICKUP
  TRAILER
  FLATBED
  REFRIGERATED
}

enum DeliveryStatus {
  PENDING
  ASSIGNED
  PICKED_UP
  IN_TRANSIT
  OUT_FOR_DELIVERY
  DELIVERED
  FAILED
  CANCELLED
}
EOF
        
        # Создаем .env файл
        cat > .env << 'EOF'
# Environment variables for Logistics Service
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/tutuu_logistics"
PORT=3004
HOST=0.0.0.0
LOG_LEVEL=info
EOF
        
        log_success "Prisma инициализирован для Logistics Service"
    else
        log_info "Prisma уже настроен для Logistics Service"
    fi
    
    cd ../..
}

# Генерация Prisma Client для всех сервисов
generate_prisma_clients() {
    log_info "Генерация Prisma Client для всех сервисов..."
    
    for service in user-service catalog-service order-service logistics-service; do
        if [ -d "services/$service/prisma" ]; then
            log_info "Генерация Prisma Client для $service..."
            cd "services/$service"
            npx prisma generate
            cd ../..
            log_success "Prisma Client сгенерирован для $service"
        fi
    done
}

# Создание миграций для всех сервисов
create_migrations() {
    log_info "Создание миграций для всех сервисов..."
    
    for service in user-service catalog-service order-service logistics-service; do
        if [ -d "services/$service/prisma" ]; then
            log_info "Создание миграции для $service..."
            cd "services/$service"
            
            # Создаем папку для миграции
            migration_name="init_${service//-/_}"
            migration_dir="prisma/migrations/$(date +%Y%m%d%H%M%S)_${migration_name}"
            mkdir -p "$migration_dir"
            
            # Создаем README для миграции
            cat > "$migration_dir/README.md" << EOF
# Миграция: Инициализация $service

**Дата**: $(date)
**Версия**: 1.0.0
**Описание**: Создание базовой структуры базы данных для $service

## 📊 Создаваемые таблицы

См. схему в prisma/schema.prisma

## 📝 Применение миграции

### Локальная разработка
\`\`\`bash
npx prisma migrate dev
\`\`\`

### Production
\`\`\`bash
npx prisma migrate deploy
\`\`\`

### Откат (если необходимо)
\`\`\`bash
npx prisma migrate reset
\`\`\`
EOF
            
            log_success "Миграция создана для $service"
            cd ../..
        fi
    done
}

# Основная функция
main() {
    echo "🚀 Начинаем настройку базы данных для всех сервисов..."
    echo ""
    
    # Проверяем Docker
    check_docker
    
    # Настраиваем каждый сервис
    setup_user_service
    setup_catalog_service
    setup_order_service
    setup_logistics_service
    
    # Генерируем Prisma Client
    generate_prisma_clients
    
    # Создаем миграции
    create_migrations
    
    echo ""
    log_success "Настройка базы данных для всех сервисов завершена!"
    echo ""
    echo "📋 Следующие шаги:"
    echo "1. Запустите PostgreSQL и Redis"
    echo "2. Примените миграции: npm run db:migrate (в каждом сервисе)"
    echo "3. Заполните тестовыми данными: npm run db:seed (в user-service)"
    echo "4. Запустите сервисы: npm run dev"
    echo ""
    echo "🔗 Полезные команды:"
    echo "- Prisma Studio: npm run db:studio"
    echo "- Сброс БД: npm run db:reset"
    echo "- Генерация клиента: npm run db:generate"
}

# Запуск основной функции
main "$@"
