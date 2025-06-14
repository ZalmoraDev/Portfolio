# TODO: REWORK NEEDED
# Stage 1: Build the React app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies (cache)
COPY package.json package-lock.json* ./ 
RUN npm install

# Copy the rest of the frontend source code
COPY . .

# Build the React app for production
RUN npm run build

# Stage 2: Serve the built app with nginx
FROM nginx:alpine

# Copy the build output to nginx's public folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 5173 to serve the app
EXPOSE 5173

CMD ["nginx", "-g", "daemon off;"]

# Create a non-root user for better security
RUN useradd -ms /bin/bash appuser
USER appuser