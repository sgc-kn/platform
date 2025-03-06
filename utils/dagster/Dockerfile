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

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1

# Install dependencies
COPY pyproject.toml uv.lock /repo/
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# Copy code
COPY integrations /repo/integrations
COPY test /repo/test
COPY utils /repo/utils

# Install project itself & additional dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
  uv add dagster-k8s dagster-postgres && \
  uv sync --no-dev --frozen

# Activate virtual environment
ENV PATH="/repo/.venv/bin:$PATH"

CMD ["bash", "utils/dagster/code-location.sh"]

EXPOSE 80
