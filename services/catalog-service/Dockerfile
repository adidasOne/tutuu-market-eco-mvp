FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production || npm ci
COPY . .
EXPOSE 3002
CMD ["node", "dist/index.js"]


