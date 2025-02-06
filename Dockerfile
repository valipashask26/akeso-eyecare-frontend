# Stage 1: Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json first for better caching
COPY package.json package-lock.json ./

# Ensure devDependencies are installed (needed for vite)
RUN npm install --include=dev

COPY . . 

RUN npm run build

# Stage 2: Nginx for serving the built app
FROM nginx:alpine

# Remove default Nginx static content and replace with built files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy a custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]