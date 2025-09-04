FROM node:18-alpine

# Установка необходимых системных зависимостей
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Копируем package файлы
COPY package*.json ./

# Устанавливаем ВСЕ зависимости (включая devDependencies для сборки)
RUN npm install

# Копируем исходный код
COPY . .

# Собираем TypeScript код
RUN npm run build

# Удаляем devDependencies для уменьшения размера образа
RUN npm prune --production

# Создаем пользователя для безопасности
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Устанавливаем права доступа
RUN chown -R nodejs:nodejs /app
USER nodejs

# Открываем порт
EXPOSE 3001

# Запускаем приложение
CMD ["node", "dist/index.js"]
