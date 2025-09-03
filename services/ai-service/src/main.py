from fastapi import FastAPI
from datetime import datetime
import os

app = FastAPI(title="ai-service")


@app.get("/health")
def health() -> dict:
    return {
        "success": True,
        "service": "ai-service",
        "deviceId": os.getenv("DEVICE_ID", "unknown"),
        "timestamp": datetime.utcnow().isoformat() + "Z",
    }


