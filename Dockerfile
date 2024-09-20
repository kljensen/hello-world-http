# Use a Rust image based on Alpine
FROM rust:1.81.0-alpine3.20 as builder

# Install build dependencies
RUN apk add --no-cache musl-dev

# Set the working directory
WORKDIR /usr/src/app

# Copy the entire project
COPY . .

# Determine the system architecture and set the appropriate Rust target
RUN arch=$(uname -m) && \
    case "$arch" in \
        "x86_64")  echo "x86_64-unknown-linux-musl" > /tmp/target ;; \
        "aarch64") echo "aarch64-unknown-linux-musl" > /tmp/target ;; \
        *)         echo "Unsupported architecture: $arch" && exit 1 ;; \
    esac

# Add the target to rustup and build the project
RUN rustup target add $(cat /tmp/target) && \
    cargo build --release --target $(cat /tmp/target)

# Copy the binary to a known location
RUN cp target/$(cat /tmp/target)/release/hello-world-http /usr/local/bin/hello-world-http

# Start a new stage for a minimal runtime container
FROM scratch

# Copy the built executable from the builder stage
COPY --from=builder /usr/local/bin/hello-world-http /hello-world-http

# Set the startup command
CMD ["/hello-world-http"]