dev: setup
	mkdir -p data
	venv/bin/dagster dev

## Python dependency management

setup: venv
venv: requirements.txt requirements.dev.txt
	python -m venv venv
	venv/bin/pip install --upgrade pip
	venv/bin/pip install -r requirements.txt -r requirements.dev.txt
	touch venv

upgrade-dependencies: venv
	venv/bin/pip install pip-tools
	venv/bin/pip-compile --upgrade --strip-extras --quiet
	venv/bin/pip install -r requirements.txt -r requirements.dev.txt
	touch venv

## Secret management

setup: secrets/identity
secrets/identity:
	mkdir -p secrets/recipients
	age-keygen -o $@
	age-keygen -y $@ > "secrets/recipients/$(USER)@$(shell hostname)"
