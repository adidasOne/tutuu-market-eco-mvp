#!/usr/bin/env python3
"""
Тестовый скрипт для проверки AI Service
Использование: python test-ai-service.py
"""

import requests
import json
import time
from datetime import datetime

# Конфигурация
BASE_URL = "http://localhost:3005"
DEVICE_ID = "test-device-123"

def test_health_endpoint():
    """Тест health endpoint"""
    print("🔍 Тестирую health endpoint...")
    
    try:
        response = requests.get(f"{BASE_URL}/health", headers={"x-device-id": DEVICE_ID})
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Health check успешен: {data['status']}")
            print(f"   Service: {data['service']}")
            print(f"   Version: {data['version']}")
            print(f"   Device ID: {data['deviceId']}")
            return True
        else:
            print(f"❌ Health check неуспешен: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Не удается подключиться к AI Service")
        print("   Убедитесь, что сервис запущен на порту 3005")
        return False
    except Exception as e:
        print(f"❌ Ошибка при тестировании health endpoint: {str(e)}")
        return False

def test_root_endpoint():
    """Тест root endpoint"""
    print("\n🔍 Тестирую root endpoint...")
    
    try:
        response = requests.get(f"{BASE_URL}/", headers={"x-device-id": DEVICE_ID})
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Root endpoint успешен")
            print(f"   Message: {data['message']}")
            print(f"   Version: {data['version']}")
            print(f"   Available endpoints: {len(data['endpoints'])}")
            return True
        else:
            print(f"❌ Root endpoint неуспешен: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Ошибка при тестировании root endpoint: {str(e)}")
        return False

def test_recommendations_endpoint():
    """Тест recommendations endpoint"""
    print("\n🔍 Тестирую recommendations endpoint...")
    
    payload = {
        "user_id": "test-user-123",
        "search_query": "кирпич",
        "category": "строительные материалы",
        "budget": 50000.0
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/recommendations", 
            json=payload,
            headers={"x-device-id": DEVICE_ID}
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Recommendations endpoint успешен")
            print(f"   Message: {data['message']}")
            print(f"   Confidence: {data['confidence']}")
            print(f"   Recommendations count: {len(data['recommendations'])}")
            return True
        else:
            print(f"❌ Recommendations endpoint неуспешен: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Ошибка при тестировании recommendations endpoint: {str(e)}")
        return False

def test_price_prediction_endpoint():
    """Тест price prediction endpoint"""
    print("\n🔍 Тестирую price prediction endpoint...")
    
    payload = {
        "product_id": "prod-123",
        "market_data": {"demand": "high", "supply": "stable"},
        "historical_prices": [1000.0, 1100.0, 1200.0, 1150.0, 1300.0]
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/price-prediction", 
            json=payload,
            headers={"x-device-id": DEVICE_ID}
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Price prediction endpoint успешен")
            print(f"   Message: {data['message']}")
            print(f"   Predicted price: {data['predicted_price']}")
            print(f"   Confidence: {data['confidence']}")
            print(f"   Trend: {data['trend']}")
            return True
        else:
            print(f"❌ Price prediction endpoint неуспешен: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Ошибка при тестировании price prediction endpoint: {str(e)}")
        return False

def test_construction_estimate_endpoint():
    """Тест construction estimate endpoint"""
    print("\n🔍 Тестирую construction estimate endpoint...")
    
    payload = {
        "project_type": "жилой дом",
        "area": 150.0,
        "materials": ["кирпич", "цемент", "доски"],
        "complexity": "средняя"
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/construction-estimate", 
            json=payload,
            headers={"x-device-id": DEVICE_ID}
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Construction estimate endpoint успешен")
            print(f"   Message: {data['message']}")
            print(f"   Total estimate: {data['total_estimate']}")
            print(f"   Labor estimate: {data['labor_estimate']}")
            print(f"   Timeline: {data['timeline_days']} дней")
            return True
        else:
            print(f"❌ Construction estimate endpoint неуспешен: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Ошибка при тестировании construction estimate endpoint: {str(e)}")
        return False

def test_market_analysis_endpoint():
    """Тест market analysis endpoint"""
    print("\n🔍 Тестирую market analysis endpoint...")
    
    try:
        response = requests.get(f"{BASE_URL}/market-analysis", headers={"x-device-id": DEVICE_ID})
        
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Market analysis endpoint успешен")
            print(f"   Message: {data['message']}")
            print(f"   Demand trend: {data['market_trends']['demand']}")
            print(f"   Top categories: {', '.join(data['top_categories'])}")
            return True
        else:
            print(f"❌ Market analysis endpoint неуспешен: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Ошибка при тестировании market analysis endpoint: {str(e)}")
        return False

def main():
    """Основная функция тестирования"""
    print("🚀 Тестирование AI Service TUTUU MARKET MVP")
    print("=" * 50)
    print(f"📅 Время тестирования: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"🌐 Base URL: {BASE_URL}")
    print(f"📱 Device ID: {DEVICE_ID}")
    print("=" * 50)
    
    # Список тестов
    tests = [
        test_health_endpoint,
        test_root_endpoint,
        test_recommendations_endpoint,
        test_price_prediction_endpoint,
        test_construction_estimate_endpoint,
        test_market_analysis_endpoint
    ]
    
    # Выполнение тестов
    passed = 0
    total = len(tests)
    
    for test in tests:
        try:
            if test():
                passed += 1
            time.sleep(0.5)  # Небольшая пауза между тестами
        except Exception as e:
            print(f"❌ Критическая ошибка в тесте {test.__name__}: {str(e)}")
    
    # Результаты
    print("\n" + "=" * 50)
    print("📊 РЕЗУЛЬТАТЫ ТЕСТИРОВАНИЯ")
    print("=" * 50)
    print(f"✅ Успешно: {passed}/{total}")
    print(f"❌ Неуспешно: {total - passed}/{total}")
    print(f"📈 Процент успеха: {(passed/total)*100:.1f}%")
    
    if passed == total:
        print("\n🎉 ВСЕ ТЕСТЫ ПРОШЛИ УСПЕШНО!")
        print("   AI Service полностью функционален")
    else:
        print(f"\n⚠️  {total - passed} тестов не прошли")
        print("   Проверьте логи и настройки сервиса")
    
    print("=" * 50)

if __name__ == "__main__":
    main()
