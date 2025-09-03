import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface AuthenticatedRequest extends Request {
    user?: {
        id: string;
        email: string;
        role: string;
        deviceId?: string;
    };
}

export const authMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    try {
        const token = req.headers.authorization?.replace('Bearer ', '');

        if (!token) {
            return res.status(401).json({
                success: false,
                message: 'Токен доступа не предоставлен',
                deviceId: req.headers['x-device-id'] || 'unknown'
            });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'default-secret') as any;

        req.user = {
            id: decoded.id,
            email: decoded.email,
            role: decoded.role,
            deviceId: decoded.deviceId
        };

        next();
    } catch (error) {
        return res.status(401).json({
            success: false,
            message: 'Недействительный токен доступа',
            deviceId: req.headers['x-device-id'] || 'unknown'
        });
    }
};

export const requireRole = (roles: string[]) => {
    return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'Требуется аутентификация',
                deviceId: req.headers['x-device-id'] || 'unknown'
            });
        }

        if (!roles.includes(req.user.role)) {
            return res.status(403).json({
                success: false,
                message: 'Недостаточно прав для выполнения операции',
                deviceId: req.headers['x-device-id'] || 'unknown'
            });
        }

        next();
    };
};
