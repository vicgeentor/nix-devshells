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
          packages.default = pkgs.buildDotnetModule {
            pname = "CHANGE_ME";
            version = "0.0.1";
            src = ./.;

            # Specify the following if needed
            # projectFile = "src/project.sln";
            # nugetDeps = ./deps.json; # see "Generating and updating NuGet dependencies" section for details
            # dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
            # dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;
            # executables = [ "foo" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.
            # packNupkg = true; # This packs the project as "foo-0.1.nupkg" at `$out/share`.
            # runtimeDeps = [ ffmpeg ]; # This will wrap ffmpeg's library path into `LD_LIBRARY_PATH`.
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              dotnetCorePackages.sdk_9_0-bin
            ];
          };
        };
    };
}
