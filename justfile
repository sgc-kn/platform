# run python tests locally
test:
  uv run pytest

# start jupyter notebook server
nb:
  uv run jupyter-notebook

# update .env file with Infisical secrets
dotenv:
  infisical export --env=dev > .env || infisical login && infisical export --env=dev > .env
