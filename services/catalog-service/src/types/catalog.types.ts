export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: string;
  categoryId: string;
  sellerId: string;
  status: ProductStatus;
  images: string[];
  characteristics: ProductCharacteristic[];
  stock: StockInfo[];
  rating: number;
  reviewCount: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface Category {
  id: string;
  name: string;
  description?: string;
  parentId?: string;
  level: number;
  slug: string;
  image?: string;
  isActive: boolean;
  sortOrder: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface ProductCharacteristic {
  name: string;
  value: string;
  unit?: string;
}

export interface StockInfo {
  warehouseId: string;
  quantity: number;
  reservedQuantity: number;
  availableQuantity: number;
  location: {
    latitude: number;
    longitude: number;
    address: string;
  };
}

export interface Warehouse {
  id: string;
  name: string;
  sellerId: string;
  address: string;
  location: {
    latitude: number;
    longitude: number;
  };
  workingHours: WorkingHours;
  type: WarehouseType;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface WorkingHours {
  monday: TimeRange;
  tuesday: TimeRange;
  wednesday: TimeRange;
  thursday: TimeRange;
  friday: TimeRange;
  saturday: TimeRange;
  sunday: TimeRange;
}

export interface TimeRange {
  open: string; // HH:MM
  close: string; // HH:MM
  isWorking: boolean;
}

export enum ProductStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  OUT_OF_STOCK = 'out_of_stock',
  DISCONTINUED = 'discontinued'
}

export enum WarehouseType {
  OPEN = 'open',
  CLOSED = 'closed',
  COVERED = 'covered'
}

// Request/Response interfaces
export interface CreateProductRequest {
  name: string;
  description: string;
  price: number;
  currency: string;
  categoryId: string;
  images: string[];
  characteristics: ProductCharacteristic[];
  stock: Omit<StockInfo, 'reservedQuantity' | 'availableQuantity'>[];
}

export interface UpdateProductRequest {
  name?: string;
  description?: string;
  price?: number;
  currency?: string;
  categoryId?: string;
  images?: string[];
  characteristics?: ProductCharacteristic[];
  status?: ProductStatus;
}

export interface CreateCategoryRequest {
  name: string;
  description?: string;
  parentId?: string;
  image?: string;
  sortOrder?: number;
}

export interface UpdateCategoryRequest {
  name?: string;
  description?: string;
  parentId?: string;
  image?: string;
  sortOrder?: number;
  isActive?: boolean;
}

export interface CreateWarehouseRequest {
  name: string;
  sellerId: string;
  address: string;
  latitude: number;
  longitude: number;
  workingHours: WorkingHours;
  type: WarehouseType;
}

export interface UpdateWarehouseRequest {
  name?: string;
  address?: string;
  latitude?: number;
  longitude?: number;
  workingHours?: WorkingHours;
  type?: WarehouseType;
  isActive?: boolean;
}

// Search and filter interfaces
export interface ProductSearchRequest {
  query?: string;
  categoryId?: string;
  minPrice?: number;
  maxPrice?: number;
  sellerId?: string;
  inStock?: boolean;
  location?: {
    latitude: number;
    longitude: number;
    radius: number; // в километрах
  };
  page?: number;
  limit?: number;
  sortBy?: 'price' | 'rating' | 'createdAt' | 'name';
  sortOrder?: 'asc' | 'desc';
}

export interface ProductSearchResponse {
  products: Product[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
  filters: {
    applied: Record<string, any>;
    available: Record<string, any[]>;
  };
}
