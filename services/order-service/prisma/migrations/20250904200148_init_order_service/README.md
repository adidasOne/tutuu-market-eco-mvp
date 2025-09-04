# Миграция: Инициализация order-service

**Дата**: четверг,  4 сентября 2025 г. 20:01:48 (+09)
**Версия**: 1.0.0
**Описание**: Создание базовой структуры базы данных для order-service

## 📊 Создаваемые таблицы

См. схему в prisma/schema.prisma

## 📝 Применение миграции

### Локальная разработка
```bash
npx prisma migrate dev
```

### Production
```bash
npx prisma migrate deploy
```

### Откат (если необходимо)
```bash
npx prisma migrate reset
```
