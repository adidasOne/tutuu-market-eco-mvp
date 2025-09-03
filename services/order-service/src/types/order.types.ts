export interface Order {
  id: string;
  customerId: string;
  status: OrderStatus;
  items: OrderItem[];
  totalAmount: number;
  currency: string;
  deliveryAddress: DeliveryAddress;
  deliveryMethod: DeliveryMethod;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  estimatedDeliveryDate?: Date;
  actualDeliveryDate?: Date;
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface OrderItem {
  id: string;
  productId: string;
  productName: string;
  quantity: number;
  unitPrice: number;
  totalPrice: number;
  sellerId: string;
  warehouseId: string;
}

export interface DeliveryAddress {
  street: string;
  house: string;
  apartment?: string;
  city: string;
  region: string;
  postalCode: string;
  country: string;
  coordinates?: {
    latitude: number;
    longitude: number;
  };
}

export interface Cart {
  id: string;
  customerId: string;
  items: CartItem[];
  totalAmount: number;
  currency: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface CartItem {
  id: string;
  productId: string;
  productName: string;
  quantity: number;
  unitPrice: number;
  totalPrice: number;
  sellerId: string;
  warehouseId: string;
}

export enum OrderStatus {
  PENDING = 'pending',           // Ожидает подтверждения
  CONFIRMED = 'confirmed',       // Подтвержден
  PROCESSING = 'processing',     // В обработке
  READY_FOR_DELIVERY = 'ready_for_delivery', // Готов к доставке
  IN_DELIVERY = 'in_delivery',   // В доставке
  DELIVERED = 'delivered',       // Доставлен
  CANCELLED = 'cancelled',       // Отменен
  RETURNED = 'returned'          // Возвращен
}

export enum DeliveryMethod {
  PICKUP = 'pickup',             // Самовывоз
  DELIVERY = 'delivery',         // Доставка
  EXPRESS_DELIVERY = 'express_delivery' // Экспресс доставка
}

export enum PaymentMethod {
  CASH = 'cash',                 // Наличные
  CARD = 'card',                 // Банковская карта
  ONLINE = 'online',             // Онлайн оплата
  INVOICE = 'invoice'            // По счету
}

export enum PaymentStatus {
  PENDING = 'pending',           // Ожидает оплаты
  PAID = 'paid',                 // Оплачен
  FAILED = 'failed',             // Ошибка оплаты
  REFUNDED = 'refunded'          // Возврат средств
}

// Request/Response interfaces
export interface CreateOrderRequest {
  items: Omit<OrderItem, 'id' | 'productName' | 'totalPrice'>[];
  deliveryAddress: DeliveryAddress;
  deliveryMethod: DeliveryMethod;
  paymentMethod: PaymentMethod;
  notes?: string;
}

export interface UpdateOrderRequest {
  status?: OrderStatus;
  estimatedDeliveryDate?: Date;
  notes?: string;
}

export interface AddToCartRequest {
  productId: string;
  quantity: number;
  warehouseId: string;
}

export interface UpdateCartItemRequest {
  quantity: number;
}

export interface CreateOrderFromCartRequest {
  deliveryAddress: DeliveryAddress;
  deliveryMethod: DeliveryMethod;
  paymentMethod: PaymentMethod;
  notes?: string;
}

// Search and filter interfaces
export interface OrderSearchRequest {
  customerId?: string;
  sellerId?: string;
  status?: OrderStatus;
  dateFrom?: Date;
  dateTo?: Date;
  page?: number;
  limit?: number;
  sortBy?: 'createdAt' | 'totalAmount' | 'status';
  sortOrder?: 'asc' | 'desc';
}

export interface OrderSearchResponse {
  orders: Order[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

// Notification interfaces
export interface OrderNotification {
  orderId: string;
  customerId: string;
  type: 'status_change' | 'delivery_update' | 'payment_reminder';
  message: string;
  data: Record<string, any>;
  createdAt: Date;
}
