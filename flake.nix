{
  description = "Some nice and instantly retrievable Nix devshell templates ";

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
          packages = rec {
            givenv = pkgs.stdenv.mkDerivation {
              pname = "givenv";
              version = "0.1";
              src = ./src;

              dontConfigure = true;
              dontBuild = true;

              installPhase = ''
                mkdir -p $out/bin

                cp -r $src/templates $out

                cp $src/givenv.sh ./givenv.tmp
                substituteInPlace ./givenv.tmp \
                  --replace-quiet "@template_dir@" "$out/templates"
                install -m755 ./givenv.tmp $out/bin/givenv
              '';
            };
            default = givenv;
          };
        };
    };
}
