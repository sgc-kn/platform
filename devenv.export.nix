{ pkgs, lib, config, inputs, ... }:

{
  devcontainer.enable = true;

  # The following settings go directly into the .devcontainer.json file.
  devcontainer.settings = {
    customizations.vscode.extensions = [
      "charliermarsh.ruff" # code formatting and linting
      "mkhl.direnv" # recommended setup for devenv/devcontainer
      "ms-toolsai.jupyter" # notebook support
    ];
    customizations.vscode.settings = {
      direnv.restart.automatic = true;
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

  packages = [
    pkgs.git
    pkgs.git-lfs

    # secrets management
    pkgs.age
    pkgs.sops
  ];

  languages.python.enable = true;
  languages.python.venv.enable = true;

  scripts.setup.exec = ''
    if [ "$CODESPACES" == "true" ] ; then
      setup-codespaces
      setup-age-from-env
    else
      setup-age-local
    fi

    setup-git-lfs
  '';

  scripts.setup-age-local.exec = ''
    # create identity for secret management

    mkdir -p ''${PLATFORM_REPO}secrets/recipients

    if [ ! -e ''${PLATFORM_REPO}secrets/identity ] ; then
      age-keygen -o ''${PLATFORM_REPO}secrets/identity
    fi

    age-keygen -y ''${PLATFORM_REPO}secrets/identity \
      > "''${PLATFORM_REPO}secrets/recipients/''${USER}@$(hostname)"
  '';

  scripts.setup-codespaces.exec = ''
    # rewrite git remotes to use http w/ access token
    git config --global --list | grep -o '^url.https://x-access-token:[^=]*' | xargs -n1 git config --global --unset-all
    git config --global --add url.https://x-access-token:''${GITHUB_TOKEN}@github.com/.insteadOf ssh://git@github.com/
    git config --global --add url.https://x-access-token:''${GITHUB_TOKEN}@github.com/.insteadOf git@github.com/
    git config --global --add url.https://x-access-token:''${GITHUB_TOKEN}@github.com/.insteadOf git@github.com:

    # update and/or initialize all submodules
    git submodule update --init --recursive

    # allow diffing git-lfs files
    git config diff.lfs.textconv cat
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
      mkdir -p ''${PLATFORM_REPO}secrets/recipients
      echo "''${AGE_SECRET_KEY}" > ''${PLATFORM_REPO}secrets/identity
      age-keygen -y ''${PLATFORM_REPO}secrets/identity \
        > "''${PLATFORM_REPO}secrets/recipients/''${GITHUB_USER}@github-codespaces"
    fi
  '';

  scripts.setup-git-lfs.exec = ''
    git lfs install --local
    git lfs pull
  '';

  scripts.sops-wrapper.exec = ''
    set -euo pipefail

    SOPS_AGE_RECIPIENTS=$(cat ''${PLATFORM_REPO}secrets/recipients/* | paste -sd,)
    export SOPS_AGE_RECIPIENTS

    SOPS_AGE_KEY_FILE=''${PLATFORM_REPO}secrets/identity
    export SOPS_AGE_KEY_FILE

    exec sops --age "$SOPS_AGE_RECIPIENTS" $@
  '';

  scripts.sops-reencrypt.exec = ''
    set -euo pipefail

    sops-wrapper decrypt -i ''${PLATFORM_REPO}secrets/secrets.yaml
    sops-wrapper encrypt -i ''${PLATFORM_REPO}secrets/secrets.yaml
  '';

  enterShell = ''
    setup
  '';
}
