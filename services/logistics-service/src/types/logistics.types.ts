export interface Delivery {
  id: string;
  orderId: string;
  carrierId: string;
  status: DeliveryStatus;
  pickupAddress: Address;
  deliveryAddress: Address;
  estimatedPickupTime: Date;
  estimatedDeliveryTime: Date;
  actualPickupTime?: Date;
  actualDeliveryTime?: Date;
  route: Route;
  cost: number;
  currency: string;
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Address {
  street: string;
  house: string;
  apartment?: string;
  city: string;
  region: string;
  postalCode: string;
  country: string;
  coordinates: {
    latitude: number;
    longitude: number;
  };
  contactPerson?: string;
  contactPhone?: string;
}

export interface Route {
  id: string;
  distance: number; // в километрах
  duration: number; // в минутах
  waypoints: Waypoint[];
  trafficConditions: TrafficCondition;
  estimatedFuelConsumption: number; // в литрах
}

export interface Waypoint {
  order: number;
  address: Address;
  coordinates: {
    latitude: number;
    longitude: number;
  };
  estimatedTime: Date;
  type: 'pickup' | 'delivery' | 'transit';
}

export interface Carrier {
  id: string;
  name: string;
  type: CarrierType;
  contactPerson: string;
  contactPhone: string;
  contactEmail: string;
  vehicles: Vehicle[];
  rating: number;
  completedDeliveries: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface Vehicle {
  id: string;
  type: VehicleType;
  model: string;
  licensePlate: string;
  capacity: number; // в кг
  dimensions: {
    length: number;
    width: number;
    height: number;
  };
  isAvailable: boolean;
}

export interface DeliveryRequest {
  id: string;
  orderId: string;
  pickupAddress: Address;
  deliveryAddress: Address;
  items: DeliveryItem[];
  totalWeight: number;
  totalVolume: number;
  specialRequirements?: string[];
  preferredDeliveryTime?: Date;
  createdAt: Date;
  expiresAt: Date;
}

export interface DeliveryItem {
  productId: string;
  productName: string;
  quantity: number;
  weight: number;
  volume: number;
  isFragile: boolean;
  requiresSpecialHandling: boolean;
}

export enum DeliveryStatus {
  PENDING = 'pending',           // Ожидает назначения перевозчика
  ASSIGNED = 'assigned',         // Назначен перевозчик
  PICKUP_SCHEDULED = 'pickup_scheduled', // Запланирован вывоз
  IN_TRANSIT = 'in_transit',     // В пути
  OUT_FOR_DELIVERY = 'out_for_delivery', // Вышел на доставку
  DELIVERED = 'delivered',       // Доставлен
  FAILED = 'failed',             // Доставка не удалась
  CANCELLED = 'cancelled'        // Отменена
}

export enum CarrierType {
  INDIVIDUAL = 'individual',     // ИП
  COMPANY = 'company',           // Компания
  SELF_EMPLOYED = 'self_employed' // Самозанятый
}

export enum VehicleType {
  CAR = 'car',                   // Легковой автомобиль
  VAN = 'van',                   // Микроавтобус
  TRUCK = 'truck',               // Грузовик
  FLATBED = 'flatbed',          // Открытый грузовик
  REFRIGERATED = 'refrigerated' // Рефрижератор
}

export enum TrafficCondition {
  CLEAR = 'clear',               // Свободно
  MODERATE = 'moderate',         // Умеренно
  HEAVY = 'heavy',               // Загружено
  CONGESTED = 'congested'        // Пробка
}

// Request/Response interfaces
export interface CreateDeliveryRequest {
  orderId: string;
  pickupAddress: Address;
  deliveryAddress: Address;
  items: Omit<DeliveryItem, 'productId'>[];
  specialRequirements?: string[];
  preferredDeliveryTime?: Date;
}

export interface UpdateDeliveryRequest {
  status?: DeliveryStatus;
  estimatedPickupTime?: Date;
  estimatedDeliveryTime?: Date;
  notes?: string;
}

export interface AssignCarrierRequest {
  carrierId: string;
  estimatedPickupTime: Date;
  estimatedDeliveryTime: Date;
  cost: number;
  currency: string;
}

export interface CreateCarrierRequest {
  name: string;
  type: CarrierType;
  contactPerson: string;
  contactPhone: string;
  contactEmail: string;
  vehicles: Omit<Vehicle, 'id' | 'isAvailable'>[];
}

export interface UpdateCarrierRequest {
  name?: string;
  contactPerson?: string;
  contactPhone?: string;
  contactEmail?: string;
  isActive?: boolean;
}

// Search and filter interfaces
export interface DeliverySearchRequest {
  orderId?: string;
  carrierId?: string;
  status?: DeliveryStatus;
  dateFrom?: Date;
  dateTo?: Date;
  pickupCity?: string;
  deliveryCity?: string;
  page?: number;
  limit?: number;
  sortBy?: 'createdAt' | 'estimatedDeliveryTime' | 'cost';
  sortOrder?: 'asc' | 'desc';
}

export interface DeliverySearchResponse {
  deliveries: Delivery[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

// Real-time tracking
export interface DeliveryTracking {
  deliveryId: string;
  currentLocation: {
    latitude: number;
    longitude: number;
    timestamp: Date;
  };
  status: DeliveryStatus;
  estimatedTimeToDestination: number; // в минутах
  lastUpdate: Date;
}

// Notification interfaces
export interface DeliveryNotification {
  deliveryId: string;
  type: 'status_change' | 'location_update' | 'delay_warning';
  message: string;
  data: Record<string, any>;
  createdAt: Date;
}
