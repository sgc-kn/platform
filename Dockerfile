# Dagster code location; adapted from
# https://docs.dagster.io/guides/deploy/deployment-options/kubernetes/deploying-to-kubernetes

FROM ghcr.io/astral-sh/uv:debian-slim

# Make sure that logs show up immediately
ENV PYTHONUNBUFFERED=1

# Copy entire repository
COPY . /repo
WORKDIR /repo/

# create and activate virtual environment
RUN uv sync --frozen
ENV PATH="/app/.venv/bin:$PATH"
