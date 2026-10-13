# DWP Container Task

A Flask application running with Gunicorn. The Dockerfile has been
updated, with no changes to the files in `app/`.

## Changes

- Python slim base image pinned to a digest.
- Removed unnecessary system packages.
- Dependencies installed before copying the application.
- Application runs as a non-root user.
- Added a health check for `/healthz`.
- Logs sent to stdout and stderr.
- Added `.dockerignore` to limit the build context.

## Build

Run from the repository root:

```sh
docker build -t ghcr.io/dwpomeke/dwp-omeke:v1 .
```

## Run

```sh
docker run -d --name dwp-greeting -p 127.0.0.1:8080:8080 ghcr.io/dwpomeke/dwp-omeke:v1
```

Open these URLs:

- http://localhost:8080/ — greeting
- http://localhost:8080/healthz — health check
- http://localhost:8080/info — application configuration

## Configuration

Environment variables can be passed using `docker run -e`.

| Variable | Default |
| --- | --- |
| `PORT` | `8080` |
| `WEB_CONCURRENCY` | `2` |
| `GREETING` | `Hello from the sample app!` |

## Checks

Check the container status, logs and runtime user:

```sh
docker ps --filter name=dwp-greeting
docker logs dwp-greeting
docker exec dwp-greeting id
```

The runtime UID and GID should both be `10001`.

Check container health:

```sh
docker inspect --format "{{.State.Health.Status}}" dwp-greeting
```

Expected result after startup: `healthy`.

## Publish

```sh
docker login ghcr.io -u dwpomeke
docker push ghcr.io/dwpomeke/dwp-omeke:v1
```

Set the package visibility to **Public**, then check anonymous access:

```sh
docker logout ghcr.io
docker pull ghcr.io/dwpomeke/dwp-omeke:v1
```

## Clean up

```sh
docker stop dwp-greeting
docker rm dwp-greeting
```