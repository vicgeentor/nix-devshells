{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem =
        { pkgs, ... }:
        let
          R-with-packages = pkgs.rWrapper.override {
            packages = with pkgs.rPackages; [
              ggplot2
              ggpubr
              rmarkdown
              styler
              tidyverse
            ];
          };
        in

        {

          devShells.default = pkgs.mkShell {
            packages = [ R-with-packages ];
          };
        };
    };
}
