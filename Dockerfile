# syntax=docker/dockerfile:1

FROM python:3.12-slim-bookworm@sha256:34386ef0cb081344d7ec1c103ba398e6e9f64e9ab3a1509accc92a4e24a07258
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    WEB_CONCURRENCY=2

WORKDIR /app

COPY --chmod=0444 app/requirements.txt ./requirements.txt
RUN python -m pip install \
        --no-cache-dir \
        --only-binary=:all: \
        -r requirements.txt \
    && python -m pip check

RUN groupadd --gid 10001 app \
    && useradd \
        --uid 10001 \
        --gid 10001 \
        --no-create-home \
        --no-log-init \
        --shell /usr/sbin/nologin \
        app
COPY --chmod=0444 app/app.py ./app.py
USER 10001:10001
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD ["python", "-c", "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:' + os.environ['PORT'] + '/healthz', timeout=2).close()"]
CMD ["gunicorn", "--access-logfile", "-", "--error-logfile", "-", "app:app"]