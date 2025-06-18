FROM node:20-alpine
WORKDIR /app
COPY ./frontend .

RUN npm install && npm run build

# Keep dist/ ready for Nginx to serve
