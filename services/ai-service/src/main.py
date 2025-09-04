from fastapi import FastAPI, HTTPException, Header, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List
import os
import logging
import sys

# Настройка логирования
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('ai_service.log')
    ]
)
logger = logging.getLogger(__name__)

# Создание FastAPI приложения
app = FastAPI(
    title="TUTUU MARKET AI Service",
    description="AI-powered service for construction materials ecosystem",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic модели
class HealthResponse(BaseModel):
    success: bool
    service: str
    deviceId: str
    timestamp: str
    version: str
    status: str

class ProductRecommendationRequest(BaseModel):
    user_id: str
    search_query: Optional[str] = None
    category: Optional[str] = None
    budget: Optional[float] = None
    location: Optional[dict] = None

class ProductRecommendationResponse(BaseModel):
    success: bool
    message: str
    deviceId: str
    recommendations: List[dict]
    confidence: float

class PricePredictionRequest(BaseModel):
    product_id: str
    market_data: dict
    historical_prices: List[float]

class PricePredictionResponse(BaseModel):
    success: bool
    message: str
    deviceId: str
    predicted_price: float
    confidence: float
    trend: str

class ConstructionEstimateRequest(BaseModel):
    project_type: str
    area: float
    materials: List[str]
    complexity: str

class ConstructionEstimateResponse(BaseModel):
    success: bool
    message: str
    deviceId: str
    total_estimate: float
    materials_breakdown: List[dict]
    labor_estimate: float
    timeline_days: int

# Helper function to get device ID
def get_device_id(device_id: Optional[str] = Header(None)) -> str:
    return device_id or "unknown"

# Middleware для логирования запросов
@app.middleware("http")
async def log_requests(request: Request, call_next):
    device_id = request.headers.get("x-device-id", "unknown")
    start_time = datetime.utcnow()
    
    logger.info(f"Request: {request.method} {request.url} - Device ID: {device_id}")
    
    response = await call_next(request)
    
    process_time = (datetime.utcnow() - start_time).total_seconds()
    logger.info(f"Response: {response.status_code} - Process Time: {process_time:.3f}s")
    
    return response

# Health check endpoint
@app.get("/health", response_model=HealthResponse)
def health(device_id: str = Header(None, alias="x-device-id")):
    try:
        return HealthResponse(
            success=True,
            service="ai-service",
            deviceId=get_device_id(device_id),
            timestamp=datetime.utcnow().isoformat() + "Z",
            version="1.0.0",
            status="healthy"
        )
    except Exception as e:
        logger.error(f"Health check error: {str(e)}")
        raise HTTPException(status_code=500, detail="Health check failed")

# Root endpoint
@app.get("/")
def root(device_id: str = Header(None, alias="x-device-id")):
    try:
        return {
            "success": True,
            "message": "TUTUU MARKET AI Service API",
            "version": "1.0.0",
            "deviceId": get_device_id(device_id),
            "endpoints": {
                "health": "/health",
                "recommendations": "/recommendations",
                "price_prediction": "/price-prediction",
                "construction_estimate": "/construction-estimate",
                "market_analysis": "/market-analysis"
            },
            "documentation": {
                "swagger": "/docs",
                "redoc": "/redoc"
            }
        }
    except Exception as e:
        logger.error(f"Root endpoint error: {str(e)}")
        raise HTTPException(status_code=500, detail="Service unavailable")

# Product recommendations endpoint
@app.post("/recommendations", response_model=ProductRecommendationResponse)
def get_product_recommendations(
    request: ProductRecommendationRequest,
    device_id: str = Header(None, alias="x-device-id")
):
    try:
        logger.info(f"Product recommendations request - User: {request.user_id}, Device: {get_device_id(device_id)}")
        
        # TODO: Implement AI recommendation logic
        # TODO: Use machine learning models for personalized recommendations
        
        recommendations = [
            {
                "product_id": "rec-1",
                "name": "Рекомендуемый товар 1",
                "confidence": 0.85,
                "reason": "Популярный выбор для вашей категории"
            },
            {
                "product_id": "rec-2", 
                "name": "Рекомендуемый товар 2",
                "confidence": 0.78,
                "reason": "Соответствует вашему бюджету"
            }
        ]
        
        return ProductRecommendationResponse(
            success=True,
            message="Рекомендации товаров получены",
            deviceId=get_device_id(device_id),
            recommendations=recommendations,
            confidence=0.85
        )
    except Exception as e:
        logger.error(f"Recommendations error: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail={
                "success": False,
                "message": "Ошибка при получении рекомендаций",
                "deviceId": get_device_id(device_id)
            }
        )

# Price prediction endpoint
@app.post("/price-prediction", response_model=PricePredictionResponse)
def predict_price(
    request: PricePredictionRequest,
    device_id: str = Header(None, alias="x-device-id")
):
    try:
        logger.info(f"Price prediction request - Product: {request.product_id}, Device: {get_device_id(device_id)}")
        
        # TODO: Implement price prediction logic
        # TODO: Use time series analysis and market data
        
        return PricePredictionResponse(
            success=True,
            message="Прогноз цены рассчитан",
            deviceId=get_device_id(device_id),
            predicted_price=1500.0,
            confidence=0.78,
            trend="stable"
        )
    except Exception as e:
        logger.error(f"Price prediction error: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail={
                "success": False,
                "message": "Ошибка при прогнозировании цены",
                "deviceId": get_device_id(device_id)
            }
        )

# Construction estimate endpoint
@app.post("/construction-estimate", response_model=ConstructionEstimateResponse)
def get_construction_estimate(
    request: ConstructionEstimateRequest,
    device_id: str = Header(None, alias="x-device-id")
):
    try:
        logger.info(f"Construction estimate request - Project: {request.project_type}, Device: {get_device_id(device_id)}")
        
        # TODO: Implement construction estimation logic
        # TODO: Use AI models trained on construction data
        
        return ConstructionEstimateResponse(
            success=True,
            message="Смета строительства рассчитана",
            deviceId=get_device_id(device_id),
            total_estimate=250000.0,
            materials_breakdown=[
                {
                    "material": "Кирпич",
                    "quantity": 5000,
                    "unit": "шт",
                    "cost": 150000.0
                },
                {
                    "material": "Цемент",
                    "quantity": 50,
                    "unit": "мешков",
                    "cost": 25000.0
                }
            ],
            labor_estimate=80000.0,
            timeline_days=45
        )
    except Exception as e:
        logger.error(f"Construction estimate error: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail={
                "success": False,
                "message": "Ошибка при расчете сметы",
                "deviceId": get_device_id(device_id)
            }
        )

# Market analysis endpoint
@app.get("/market-analysis")
def get_market_analysis(device_id: str = Header(None, alias="x-device-id")):
    try:
        logger.info(f"Market analysis request - Device: {get_device_id(device_id)}")
        
        # TODO: Implement market analysis logic
        # TODO: Analyze trends, demand patterns, and market dynamics
        
        return {
            "success": True,
            "message": "Анализ рынка получен",
            "deviceId": get_device_id(device_id),
            "market_trends": {
                "demand": "increasing",
                "supply": "stable",
                "price_trend": "moderate_increase"
            },
            "top_categories": ["Кирпич", "Цемент", "Доски"],
            "seasonal_factors": ["Летний сезон строительства"],
            "recommendations": [
                "Увеличить закупки кирпича",
                "Мониторить цены на цемент",
                "Подготовиться к осеннему сезону"
            ]
        }
    except Exception as e:
        logger.error(f"Market analysis error: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail={
                "success": False,
                "message": "Ошибка при анализе рынка",
                "deviceId": get_device_id(device_id)
            }
        )

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    device_id = request.headers.get("x-device-id", "unknown")
    logger.error(f"Global exception: {str(exc)} - Device: {device_id}")
    
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "message": "Внутренняя ошибка сервера",
            "deviceId": device_id,
            "error": str(exc) if os.getenv("PYTHON_ENV") == "development" else "Internal server error"
        }
    )

if __name__ == "__main__":
    import uvicorn
    
    logger.info("🚀 AI Service запущен")
    logger.info("📱 Device ID tracking: включен")
    logger.info("🤖 Рекомендации: /recommendations")
    logger.info("💰 Прогноз цен: /price-prediction")
    logger.info("🏗️ Смета строительства: /construction-estimate")
    logger.info("📊 Анализ рынка: /market-analysis")
    logger.info("📚 Документация: /docs")
    
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=3005,
        log_level="info"
    )


