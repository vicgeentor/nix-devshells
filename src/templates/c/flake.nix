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
            #   cp default_pname $out/bin/
            # '';
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              gcc
              clang
              clang-tools
            ];
            shellHook = ''
              echo "Generating .clangd with correct include paths..."

              INCLUDE_PATHS=$(clang -E -x c - -v < /dev/null 2>&1 \
                | sed -n '/#include <...> search starts here:/,/End of search list./p' \
                | grep -v '^#' \
                | grep -v 'End of search list.' \
                | sed 's/^ \{1,\}//' \
                | sed 's/.*/"-isystem", "&"/' \
                | paste -sd, -)

              cat > .clangd <<EOF
              CompileFlags:
                Add: [''${INCLUDE_PATHS}]
              EOF

              echo ".clangd generated:"
              cat .clangd
            '';
          };
        };
    };
}
