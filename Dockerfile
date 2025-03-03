ARG PYTHON_VERSION=3.13

# Dagster code location; adapted from
# https://docs.dagster.io/guides/deploy/deployment-options/kubernetes/deploying-to-kubernetes
# and
# https://docs.astral.sh/uv/guides/integration/docker/

FROM python:${PYTHON_VERSION}-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /repo

# Make sure that logs show up immediately
ENV PYTHONUNBUFFERED=1

# Install dependencies
ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ADD pyproject.toml uv.lock /repo/
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# Copy entire repository
ADD . /repo

# Install project itself
RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --no-dev --frozen

# Install additional dependencies for k8s deployment
RUN --mount=type=cache,target=/root/.cache/uv \
  uv add dagster dagster-k8s dagster-postgres

# Activate virtual environment
ENV PATH="/repo/.venv/bin:$PATH"

CMD [ "dagster", "api", "grpc", \
      "--port", "80", \
      "-m", "utils.dagster.definitions" ]

EXPOSE 80
