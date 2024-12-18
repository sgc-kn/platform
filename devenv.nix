{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/integrations/codespaces-devcontainer/
  devcontainer.enable = true;

  # The following settings go directly into the .devcontainer.json file.
  devcontainer.settings = {
    # We request read access to private Github repositories and configure a secret.
    # https://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces
    customizations.codespaces.repositories = {
      "sgc-kn/closed-data".permissions = { contents = "read"; };
    };
    # https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/specifying-recommended-secrets-for-a-repository
    secrets = {
      AGE_SECRET_KEY = {
        description = lib.strings.concatStringsSep " " [
          "We track some secrets within the git repository."
          "We secure them with SOPS & age."
          "Unlocking the secrets requires a key."
          "Generate your key with `age-keygen`."
          "Add the entire key here, including the `AGE-SECRET-KEY-` prefix."
        ];
      };
    };
  };

  # https://devenv.sh/basics/
  # env.DEVENV = "sgc-kn/platform";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.git-lfs

    # secrets management
    pkgs.age
    pkgs.sops
  ];

  # https://devenv.sh/languages/
  languages.python.enable = true;
  languages.python.venv.enable = true;
  languages.python.venv.requirements = "-e .";

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
    if [ "$CODESPACES" == "true" ] ; then
      setup-codespaces
      setup-age-from-env
    else
      setup-age-local
    fi
  '';

  scripts.setup-age-local.exec = ''
    # create identity for secret management

    mkdir -p secrets/recipients

    if [ ! -e secrets/identity ] ; then
      age-keygen -o secrets/identity
    fi

    age-keygen -y secrets/identity > "secrets/recipients/''${USER}@$(hostname)"
  '';

  scripts.setup-codespaces.exec = ''
    # rewrite git remotes to use http w/ access token
    git config --global --replace-all url.https://x-access-token:''${GITHUB_TOKEN}@github.com/.insteadOf ssh://git@github.com/
    git config --global --add         url.https://x-access-token:''${GITHUB_TOKEN}@github.com/.insteadOf git@github.com/
    git config --global --add         url.https://x-access-token:''${GITHUB_TOKEN}@github.com/.insteadOf git@github.com:

    # update and/or initialize all submodules
    git submodule update --init --recursive
  '';

  scripts.setup-age-from-env.exec = ''
    if [ -z ''${AGE_SECRET_KEY:+x} ] ; then
      echo WARNING: >&2
      echo WARNING: The AGE_SECRET_KEY environment variable is not set. >&2
      echo WARNING: The SOPS-managed secrets will be unavailable. >&2
      echo WARNING: >&2
      echo WARNING: On Github Codespaces, follow this advice: >&2
      echo WARNING: https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/specifying-recommended-secrets-for-a-repository
      echo WARNING: >&2
    else
      mkdir -p secrets/recipients
      echo "''${AGE_SECRET_KEY}" > secrets/identity
      age-keygen -y secrets/identity > "secrets/recipients/''${GITHUB_USER}@github-codespaces"
    fi
  '';

  scripts.sops-wrapper.exec = ''
    set -euo pipefail

    SOPS_AGE_RECIPIENTS=$(cat secrets/recipients/* | paste -sd,)
    export SOPS_AGE_RECIPIENTS

    SOPS_AGE_KEY_FILE=secrets/identity
    export SOPS_AGE_KEY_FILE

    exec sops --age "$SOPS_AGE_RECIPIENTS" $@
  '';

  scripts.sops-reencrypt.exec = ''
    set -euo pipefail

    sops-wrapper decrypt -i secrets/secrets.yaml
    sops-wrapper encrypt -i secrets/secrets.yaml
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
