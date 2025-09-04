# Используем Python 3.10 для лучшей совместимости с ML библиотеками
FROM python:3.10-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем переменные окружения Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Копируем requirements.txt и устанавливаем зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Копируем исходный код
COPY . .

# Создаем пользователя для безопасности
RUN useradd --create-home --shell /bin/bash app && \
    chown -R app:app /app
USER app

# Открываем порт
EXPOSE 3005

# Запускаем приложение
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "3005", "--reload"]


