# Stage 1: Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json first for better caching
COPY package.json package-lock.json ./

# Ensure devDependencies are installed (needed for vite)
RUN npm install --include=dev

COPY . . 

RUN npm run build

# Stage 2: Production stage
FROM node:18-alpine

WORKDIR /app

# Install serve globally for serving the built files
RUN npm i -g serve

# Copy only the built app from the builder stage
COPY --from=builder /app/dist ./dist

# Use a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
