# run python tests locally
test:
  uv run pytest

# start jupyter notebook server
nb:
  uv run jupyter-notebook

# start dagster development environmnet
dagster:
  uv run dagster dev

# start airflow development environment
airflow \
  $AIRFLOW_HOME=`realpath _airflow` \
  $AIRFLOW__CORE__DAGS_FOLDER=`realpath utils/airflow/dags` :
  [ -e _airflow ] || mkdir _airflow
  [ -e _airflow/airflow.cfg ] || \
    ln -s ../utils/airflow/airflow-dev.cfg _airflow/airflow.cfg
  uv run airflow standalone

# print airflow login information
airflow-login:
  @echo "location: http://localhost:8080"
  @echo "username: admin"
  @echo "password: `jq -r .admin < _airflow/simple_auth_manager_passwords.json.generated`"

# reset local airflow environment
airflow-clean:
  rm -r _airflow

# update .env file with Infisical secrets
dotenv:
  infisical export --env=dev > .env || infisical login && infisical export --env=dev > .env
