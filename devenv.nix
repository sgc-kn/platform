{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/integrations/codespaces-devcontainer/
  devcontainer.enable = true;

  # The following settings go directly into the .devcontainer.json file.
  # We request read access to private Github repositories.
  # https://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces
  devcontainer.settings.customizations.codespaces.repositories = {
    "sgc-kn/closed-data".permissions = { contents = "read"; };
  };

  # https://devenv.sh/basics/
  env.DEVENV = "sgc-kn/platform";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git

    # secrets management
    pkgs.age
    pkgs.sops
  ];

  # https://devenv.sh/languages/
  languages.python.enable = true;
  languages.python.venv.enable = true;
  languages.python.venv.requirements = ./requirements.txt;

  # https://devenv.sh/processes/
  processes.dagster = {
    exec = ''
      mkdir -p data
      dagster dev
    '';
    process-compose =  {
      availability = {
        backoff_seconds = 5;
        restart = "on_failure";
      };
    };
  };

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.setup.exec = ''
    # create identity for secret management

    if [ -e secrets/identity ] ; then
      exit 0
    fi

	  mkdir -p secrets/recipients
	  age-keygen -o secrets/identity
	  age-keygen -y secrets/identity > "secrets/recipients/$(USER)@$(shell hostname)"
  '';

  scripts.upgrade.exec = ''
    # update lock files with newest versions

    echo update requirements.txt
    pip-compile --upgrade --strip-extras --quiet
  '';

  enterShell = ''
    setup
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
