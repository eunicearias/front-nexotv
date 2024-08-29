# Usa una imagen base más ligera para construir
FROM node:18-alpine AS builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos necesarios para instalar dependencias
COPY package*.json ./

# Instala las dependencias de producción y desarrollo
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Construye la aplicación de Next.js
RUN npm run build

# Segunda etapa: usa una imagen base ligera para el servidor
FROM node:18-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia solo los archivos necesarios de la etapa de construcción
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expone el puerto que la aplicación usará
EXPOSE 3000

# Comando para ejecutar la aplicación de Next.js en modo producción
CMD ["npm", "start"]
