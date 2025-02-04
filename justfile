test:
  uv run pytest

dotenv:
  infisical export --env=prod > .env || infisical login && infisical export --env=prod > .env