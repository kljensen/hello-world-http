FROM rust:1.81.0-alpine3.20 as builder
WORKDIR /usr/src/hello-world-http
COPY . .
RUN cargo build --release

FROM scratch
COPY --from=builder /usr/src/hello-world-http/target/release/hello-world-http /
CMD ["/hello-world-http"]