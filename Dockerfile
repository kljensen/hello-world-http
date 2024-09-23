FROM alpine:3.20.3 as builder

# Install build dependencies
RUN apk add --no-cache zig upx

# Set the working directory
WORKDIR /usr/src/app

# Copy the entire project
COPY . .

RUN \
    zig build-exe -lc -static -O ReleaseSmall ./server.zig && \
    upx -9 ./server

# Start a new stage for a minimal runtime container
FROM scratch

# Copy the built executable from the builder stage
COPY --from=builder /usr/src/app/server /server

# Set the startup command
CMD ["/server"]