# 1️⃣ Builder bosqichi
FROM node:alpine as builder
WORKDIR /app

# 1.1 Faqat package.json va package-lock.json'ni nusxalash
COPY package*.json ./

# 1.2 Dependencies'larni o‘rnatish
RUN npm ci

# 1.3 Barcha loyihani nusxalash
COPY . .

# 1.4 Build qilish
RUN npm run build

# 2️⃣ Production bosqichi
FROM node:alpine
WORKDIR /app

# 2.1 Faqat tayyor dist/ fayllarni nusxalash
COPY --from=builder /app/dist ./dist

# 2.2 Faqat runtime dependencies'larni o‘rnatish (devDependencies'larni tashlab ketish)
COPY package*.json ./
RUN npm ci --omit=dev

# 2.3 Container'ni ishga tushirish
CMD ["node", "./dist/main.js"]
