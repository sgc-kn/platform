{ pkgs, lib, config, inputs, ... }:

{
  env.PLATFORM_REPO = "./";

  # https://devenv.sh/processes/
  processes.dagster = {
    exec = ''
      mkdir -p data
      uv run dagster dev
    '';
    process-compose =  {
      availability = {
        backoff_seconds = 5;
        restart = "on_failure";
      };
    };
  };
}
