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

            # Either specify buildPhase and installPhase here or use a Makefile
            # with build and install instructions.
            # E.g.,
            # buildPhase = ''
            #   make
            # '';
            # installPhase = ''
            #   mkdir -p $out/bin
            #   cp CHANGE_ME $out/bin/
            # '';
          };
          devShells.default =
            pkgs.mkShell.override
              {
                stdenv = pkgs.clangStdenv;
              }
              {
                packages = with pkgs; [
                  bear # run `bear -- make` to generate compile_commands.json for clangd to work
                  clang-tools
                  gdb
                  gef
                  gnumake
                ];
              };
        };
    };
}
