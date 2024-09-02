{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.age
    pkgs.sops

    pkgs.minikube
    pkgs.kubectl
    pkgs.kubernetes-helm

    # keep this line if you use bash
    pkgs.bashInteractive
  ];

  shellHook = ''
    alias kubectl="minikube kubectl --"
  '';
}
