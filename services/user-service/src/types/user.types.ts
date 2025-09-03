export interface User {
    id: string;
    email: string;
    phone: string;
    firstName: string;
    lastName: string;
    role: UserRole;
    status: UserStatus;
    createdAt: Date;
    updatedAt: Date;
    deviceId?: string;
}

export enum UserRole {
    CUSTOMER = 'customer',      // Заказчик
    EXECUTOR = 'executor',      // Исполнитель
    SELLER = 'seller',          // Продавец
    CARRIER = 'carrier',        // Перевозчик
    ADMIN = 'admin'             // Администратор
}

export enum UserStatus {
    ACTIVE = 'active',
    INACTIVE = 'inactive',
    SUSPENDED = 'suspended',
    PENDING_VERIFICATION = 'pending_verification'
}

export interface CreateUserRequest {
    email: string;
    phone: string;
    firstName: string;
    lastName: string;
    password: string;
    role: UserRole;
    deviceId?: string;
}

export interface UpdateUserRequest {
    firstName?: string;
    lastName?: string;
    phone?: string;
    status?: UserStatus;
}

export interface LoginRequest {
    email: string;
    password: string;
    deviceId?: string;
}

export interface LoginResponse {
    user: Omit<User, 'password'>;
    token: string;
    refreshToken: string;
}

export interface UserProfile {
    id: string;
    email: string;
    phone: string;
    firstName: string;
    lastName: string;
    role: UserRole;
    status: UserStatus;
    createdAt: Date;
    updatedAt: Date;
    // Дополнительные поля для профиля
    avatar?: string;
    bio?: string;
    rating?: number;
    completedOrders?: number;
}
