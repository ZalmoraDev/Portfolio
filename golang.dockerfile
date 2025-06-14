# TODO: REWORK NEEDED
# Stage 1: Build the Go binary
FROM golang:1.24 AS builder

WORKDIR /app

# Copy Golang module files and download dependencies (caches better)
COPY backend/golang.mod backend/golang.sum ./
RUN golang mod download

# Copy the rest of the backend source code
COPY backend/ .

# Build the Go app (adjust main package path if needed)
RUN golang build -o portfolio-golang main.golang

# Stage 2: Create a minimal image for running
FROM alpine:latest

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/portfolio-golang .

# Expose the port your app listens on (optional, for clarity)
EXPOSE 8080

# Run the binary
CMD ["./portfolio-golang"]

# Create a non-root user for better security
RUN useradd -ms /bin/bash appuser
USER appuser