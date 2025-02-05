# Step 1: Use an official Node.js runtime as a base image for building the app
FROM node:16-slim AS build

# Step 2: Set a working directory for the app
WORKDIR /app

# Step 3: Copy package files for dependency installation
COPY package*.json ./

# Step 4: Install production dependencies
RUN npm install --production

# Step 5: Install vite globally for building the app
RUN npm install -g vite

# Step 6: Copy the rest of the application code
COPY . .

# Step 7: Build the React application for production
RUN npm run build

# Step 8: Use a smaller base image for serving the built app
FROM nginx:alpine

# Step 9: Create a non-root user to run the application
RUN adduser -D -g '' appuser

# Step 10: Remove default nginx configuration to avoid potential conflicts
RUN rm /etc/nginx/conf.d/default.conf

# Step 11: Copy the custom nginx configuration (if you have one) or proceed with default
COPY nginx.conf /etc/nginx/nginx.conf

# Step 12: Copy the build artifacts from the build stage to the Nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Step 13: Set ownership and permissions for files (to ensure the non-root user can access the files)
RUN chown -R appuser:appuser /usr/share/nginx/html

# Step 14: Create required directories and set permissions
RUN mkdir -p /var/cache/nginx/client_temp && \
    chown -R appuser:appuser /var/cache/nginx

# Step 15: Switch to the non-root user for security
USER appuser

# Step 16: Expose the port for the container
EXPOSE 80

# Step 17: Run the Nginx server as the non-root user
CMD ["nginx", "-g", "daemon off;"]
