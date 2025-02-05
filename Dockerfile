# Step 1: Use an official Node.js runtime as a base image for building the app
FROM node:16-slim AS build

# Step 2: Set a working directory for the app
WORKDIR /app

# Step 3: Copy package files for dependency installation
COPY package*.json ./

# Step 4: Install all dependencies, including development dependencies
RUN npm install

# Step 5: Install Vite globally for building the app
RUN npm install -g vite

# Step 6: Copy the rest of the application code
COPY . .

# Step 7: Build the React application for production
RUN npm run build

# Step 8: Use a smaller base image for serving the built app
FROM nginx:alpine

# Step 9: Create a non-root user to run the application
RUN adduser -D -g '' appuser

# Step 10: Fix permissions for directories that require access by nginx process
RUN mkdir -p /var/run && \
    chown -R appuser:appuser /var/run && \
    chmod 755 /var/run

# Step 11: Remove default nginx configuration to avoid potential conflicts
RUN rm /etc/nginx/conf.d/default.conf

# Step 12: Copy the custom nginx configuration (if you have one) or proceed with default
COPY nginx.conf /etc/nginx/nginx.conf

# Step 13: Copy the build artifacts from the build stage to the Nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Step 14: Set ownership and permissions for files (to ensure the non-root user can access the files)
RUN chown -R appuser:appuser /usr/share/nginx/html

# Step 15: Set ownership and permissions for /var/cache/nginx directory (to avoid cache issues)
RUN mkdir -p /var/cache/nginx/client_temp && \
    chown -R appuser:appuser /var/cache/nginx

# Step 16: Switch to the non-root user for security
USER appuser

# Step 17: Expose the port for the container
EXPOSE 80

# Step 18: Run the Nginx server as the non-root user
CMD ["nginx", "-g", "daemon off;"]
