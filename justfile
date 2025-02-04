# run python tests locally
test:
  uv run pytest

# update .env file with Infisical secrets
dotenv:
  infisical export --env=prod > .env || infisical login && infisical export --env=prod > .env
