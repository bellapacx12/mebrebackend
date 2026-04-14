# Use official Go image as builder
FROM golang:1.24-alpine AS builder

# Install git for go modules
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the code
COPY . .

# Build the binary
RUN go build -o bingo-backend main.go

# Final image
FROM alpine:latest

# Install CA certs
RUN apk --no-cache add ca-certificates

# Set working directory
WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/bingo-backend .
COPY --from=builder /app/services ./services

# Expose port
EXPOSE 4000

# Environment variables can be set in Docker run
ENV PORT=4000

# Run the server
CMD ["./bingo-backend"]
