# Используем базовый образ Node.js для сборки
FROM node:18-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости, включая Astro CLI
RUN npm install

# Копируем исходный код
COPY . .

# Собираем проект
RUN npm run build

# Используем базовый образ Nginx для финального образа
FROM nginx:alpine

# Копируем собранные файлы из builder в Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Открываем порт 80
EXPOSE 80

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]