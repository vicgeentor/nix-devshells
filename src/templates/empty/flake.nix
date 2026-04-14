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
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "CHANGE_ME";
            version = "0.0.1";
            src = ./.;
          };
          devShells.default = pkgs.mkShell {
            # The Nix packages provided in the environment
            # Add any you need here
            packages = [ ];

            # Set any environment variables for your dev shell
            env = { };

            # Add any shell logic you want executed any time the environment is activated
            shellHook = "";
          };
        };
    };
}
