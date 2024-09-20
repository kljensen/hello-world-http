# Use a multi-arch compatible Rust image
FROM --platform=$BUILDPLATFORM rust:1.81.0-alpine3.20 as builder

# Install build dependencies
RUN apk add --no-cache musl-dev

# Set the working directory
WORKDIR /usr/src/app
COPY . .

# Build dependencies - this will be cached if dependencies don't change
RUN cargo build --release

# Use build arguments to specify the target architecture
ARG TARGETARCH
ARG BUILDPLATFORM

# Set the Rust target based on the build architecture
RUN case "$TARGETARCH" in \
        "amd64")  echo "x86_64-unknown-linux-musl" > /tmp/target ;; \
        "arm64")  echo "aarch64-unknown-linux-musl" > /tmp/target ;; \
        *)        echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac

# Add the target to rustup and build the project
RUN rustup target add $(cat /tmp/target) && \
    cargo build --release --target $(cat /tmp/target)

RUN cp target/$(cat /tmp/target)/release/hello-world-http /usr/local/bin/hello-world-http

# Start a new stage for a minimal runtime container
FROM scratch

# Copy the built executable from the builder stage
COPY --from=builder /usr/local/bin/hello-world-http /hello-world-http


# Set the startup command
CMD ["/hello-world-http"]