# Tiny Hello World HTTP

The goal of this project is to be the _smallest possible_ Docker
image for testing HTTP services.  The server responds to all HTTP
requests with a simple "Hello, World!" As of v0.5.0, the Docker
container is just 23kB.

## Running with Docker

To run this with Docker, do something like

```sh
docker run \
  -e HOST=0.0.0.0 -e PORT=8000 \
  -p 8000:8000 --init \
  ghcr.io/kljensen/hello-world-http:latest
```

Notice:

- `HOST` and `PORT` are _required_.
- `HOST` must be in dotted decimal, like `0.0.0.0`
- If `HOST` is something other than `0.0.0.0`, your
container will likely not respond to external requests.
- `PORT` is the port on which the server will listen
inside the container. If you're forwarding from the 
host to the container, obviously this needs to match
the port you publish with `-p`. See [the Docker documentation](https://docs.docker.com/engine/network/#published-ports).
- The `--init` flag is optional, but it's a good idea to
use it. It ensures that the server process is stopped
properly when Docker gets a `SIGTERM` signal. (For example,
this will make `docker run` handle `Ctrl-C` properly.)

## Running with Docker Compose

To run this with Docker Compose, you should have a
`docker-compose.yml` file that looks something like

```yaml
services:
  hello-world:
    image: ghcr.io/kljensen/hello-world-http:latest
    init: true
    ports:
      - "8000:8000"
    environment:
      - HOST=0.0.0.0
      - PORT=8000
```

Then you can run it with

```sh
docker-compose up
```

## Related projects

- [crccheck/docker-hello-world](https://github.com/crccheck/docker-hello-world)