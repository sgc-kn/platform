{ pkgs, lib, config, inputs, ... }:

{
  env.PLATFORM_REPO = "./";

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

  scripts.upgrade.exec = ''
    # update lock files with newest versions

    echo update requirements.txt
    pip-compile --upgrade --strip-extras --quiet
  '';
}
