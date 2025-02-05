# Step 1: Use an official Node.js runtime as a base image for building the app
FROM node:16-slim AS build

# Step 2: Set a working directory for the app
WORKDIR /app

# Step 3: Copy package files for dependency installation
COPY package*.json ./

# Step 4: Install only the necessary dependencies (without dev dependencies for production)
RUN npm install --production

# Step 5: Copy the rest of the application code
COPY . .

# Step 6: Build the React application for production
RUN npm run build

# Step 7: Use a smaller base image for serving the built app
FROM nginx:alpine

# Step 8: Create a non-root user to run the application
RUN adduser -D -g '' appuser

# Step 9: Remove default nginx configuration to avoid potential conflicts
RUN rm /etc/nginx/conf.d/default.conf

# Step 10: Copy the custom nginx configuration (if you have one) or proceed with default
COPY nginx.conf /etc/nginx/nginx.conf

# Step 11: Copy the build artifacts from the build stage to the Nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Step 12: Set ownership and permissions for files (to ensure the non-root user can access the files)
RUN chown -R appuser:appuser /usr/share/nginx/html

# Step 13: Create required directories and set permissions
RUN mkdir -p /var/cache/nginx/client_temp && \
    chown -R appuser:appuser /var/cache/nginx

# Step 14: Switch to the non-root user for security
USER appuser

# Step 15: Expose the port for the container
EXPOSE 80

# Step 16: Run the Nginx server as the non-root user
CMD ["nginx", "-g", "daemon off;"]
