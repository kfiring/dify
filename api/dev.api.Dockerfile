FROM python:3.10-slim-bookworm

COPY debian.sources.list /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gcc g++ libc-dev libffi-dev libgmp-dev libmpfr-dev libmpc-dev \
       curl wget vim nodejs ffmpeg \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip pip install -r /tmp/requirements.txt \
    && rm -rf /tmp/requirements.txt

ENV FLASK_APP app.py
ENV EDITION SELF_HOSTED
ENV DEPLOY_ENV PRODUCTION
ENV CONSOLE_API_URL http://127.0.0.1:5001
ENV CONSOLE_WEB_URL http://127.0.0.1:3000
ENV SERVICE_API_URL http://127.0.0.1:5001
ENV APP_WEB_URL http://127.0.0.1:3000

ARG COMMIT_SHA
ENV COMMIT_SHA ${COMMIT_SHA}

ENV TZ UTC

EXPOSE 5001

WORKDIR /dify