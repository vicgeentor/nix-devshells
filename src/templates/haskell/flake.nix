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
          pkg = pkgs.haskellPackages.developPackage { root = ./.; };
        in
        {
          packages = rec {
            hattier = pkg;
            default = hattier;
          };
          devShells.default = pkgs.haskellPackages.shellFor {
            packages = _: [ pkg ];
            nativeBuildInputs = with pkgs; [
              cabal-install
              ghc
              haskellPackages.cabal-fmt
              haskell-language-server
            ];
          };
        };
    };
}
