{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.age
    pkgs.sops

    # keep this line if you use bash
    pkgs.bashInteractive
  ];
}
