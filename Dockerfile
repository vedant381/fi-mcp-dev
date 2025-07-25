# ---- Build Stage ----
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Install git (required for go mod if using private repos)
RUN apk add --no-cache git

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go app
RUN go build -o server main.go

# ---- Run Stage ----
FROM alpine:latest

WORKDIR /app

# Copy the built binary from the builder
COPY --from=builder /app/server .
# Copy static files and test data if needed at runtime
COPY static ./static
COPY test_data_dir ./test_data_dir

# Expose the port your app runs on (change if not 8080)
EXPOSE 8080

# Run the binary
CMD ["./server"] 