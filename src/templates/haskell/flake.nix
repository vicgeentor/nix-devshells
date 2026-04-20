{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { config, pkgs, ... }:
        {
          packages = rec {
            CHANGE_ME = pkgs.haskellPackages.developPackage { root = ./.; };
            default = CHANGE_ME;
          };

          devShells.default = pkgs.haskellPackages.shellFor {
            packages = _: [ config.packages.default ];
            nativeBuildInputs = with pkgs; [
              cabal-install
              ghc
              haskellPackages.cabal-fmt
              haskell-language-server
              hlint
            ];
            shellHook = config.pre-commit.shellHook;
          };

          pre-commit.settings = {
            hooks = {
              nixfmt.enable = true;
              cabal-fmt.enable = true;
              ormolu.enable = true;
              hlint.enable = true;
            };
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              cabal-fmt.enable = true;
              ormolu.enable = true;
              hlint.enable = true;
            };
          };
        };
    };
}
