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
        {
          overlays.default = final: prev: {
            rEnv = final.rWrapper.override {
              packages = with final.rPackages; [
                rmarkdown
                tidyverse
                ggplot2
                ggpubr
                languageserver

                # Required for grind.R by Rob de Boer
                coda
                deSolve
                rootSolve
                FME
              ];
            };
          };

          devShells.default = pkgs.mkShell {
            packages = [ pkgs.rEnv ];
          };
        };
    };
}
