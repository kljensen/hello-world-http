# Hello world http

This is a simple hello world http server written in Rust.
I wrote this to use as a very tiny Docker image for testing
HTTP services.

## Running with Docker

To run this with Docker, do something like

```sh
docker run -e HOST=0.0.0.0 -p 8000:8000 ghcr.io/kljensen/hello-world-http:latest
```

The `HOST` will tell the server to listen for outisde
requests. The `-p 8000:8000` will map the container's
port 8000 to the host's port 8000.

## Running with Docker Compose

To run this with Docker Compose, you should have a 
`docker-compose.yml` file that looks something like

```yaml
services:
  hello-world:
    image: ghcr.io/kljensen/hello-world-http:latest
    ports:
      - "8000:8000"
    environment:
      - HOST=0.0.0.0
```

Then you can run it with

```sh
docker-compose up
```