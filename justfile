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

# install given airflow version and add to pyproject and uv.lock
# following https://airflow.apache.org/docs/apache-airflow/stable/start.html
# oh wow! airflow seems to be pinning half the python ecosystem to specific versions.
# what a mess!
# TODO think about decoupling. Can we run the task with their own python env?
airflow-install-version version:
  #!/usr/bin/env bash
  PYTHON=`uv run python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")'`
  CONSTRAINTS="https://raw.githubusercontent.com/apache/airflow/constraints-{{version}}/constraints-${PYTHON}.txt"
  uv add "apache-airflow=={{version}}" --constraint "${CONSTRAINTS}"

# install default airflow version
airflow-install:
  just airflow-install-version 3.0.6


# update .env file with Infisical secrets
dotenv:
  infisical export --env=dev > .env || infisical login && infisical export --env=dev > .env
