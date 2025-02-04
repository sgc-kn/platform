{ pkgs, lib, config, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
in

{
  packages = [
    pkgs.git
    pkgs.git-lfs

    # secrets management
    unstable.infisical
    unstable.just
  ];

  languages.python.enable = true;
  languages.python.uv.enable = true;
  languages.python.uv.package = unstable.uv;
  languages.python.uv.sync.enable = true;

  scripts.setup.exec = ''
    setup-git
  '';

  scripts.setup-git.exec = ''
    # similar to .devcontainer/postCreate.sh

    # configure git lfs
    git lfs install --local # automate git lfs pull in the future
    git lfs pull # get large files

    # configure submodules
    git submodule update --init --recursive
    git submodule foreach --recursive 'git lfs install --local && git lfs pull'
  '';

  enterShell = ''
    setup
  '';
}
