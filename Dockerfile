# Stage 1: Build the app using Node.js
FROM node:16 AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the package.json and install dependencies
COPY package.json ./
RUN npm install -f

# Copy the rest of the application code
COPY . .

# Install Vite globally for building the app
RUN npm install -g vite

# Build the app
RUN npm run build

### Stage 2: Run the app with Nginx ###
FROM nginx:1.17.1-alpine

# Copy the custom Nginx configuration file (if any)
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the built app from the build stage to the Nginx HTML directory
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Create a non-root user for security reasons
RUN adduser -D -g '' appuser

# Change ownership of the Nginx directory to the non-root user
RUN chown -R appuser:appuser /usr/share/nginx/html

# Switch to the non-root user
USER appuser

# Expose port 80 to access the app
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
