# Some simple Nix devshell templates

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This very simple project lets you import simple
[Nix development shells](https://nixos.wiki/wiki/Development_environment_with_nix-shell)
to your current directory through the `givenv` command. You can
then use these shells to develop your projects and manage your
dependencies [the Nix way](https://github.com/the-nix-way)!

These devshells are made for myself, so you should modify each
flake.nix file for your own needs.

This project is heavily inspired by and copied from
[the-nix-way/dev-templates](https://github.com/the-nix-way/dev-templates).

## Requirements

- A system with [Nix](https://nixos.org/) installed (with flakes
  enabled)
- (optional)
  [direnv](https://github.com/nix-community/nix-direnv)

## Installation

Add this project's flake to your NixOS or home-manager flake
inputs:

```nix
...

inputs = {
  ... 

  givenv = {
    url = "github:vicgeentor/givenv";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ...
};

...
```

And then add it either `environment.systemPackages` or
`home.packages` as

```nix
inputs.givenv.packages.${pkgs.stdenv.hostPlatform.system}.default
```

Then rebuild your NixOS or home-manager system.

> [!TIP]
> If you are unfamiliar with these practices, check out
> [this amazing source](https://nixos-and-flakes.thiscute.world/)
> to learn how Nix flakes work and how they make your
> development life easier.

## Usage

```bash
givenv $template
```

where `$template` is one of the directory names inside
[src/templates](https://github.com/vicgeentor/givenv/tree/main/src/templates).

This will copy `flake.nix`, `flake.lock`, `.envrc`, and
`.gitignore` from the template directory that you chose to your
current directory. You can then run

```bash
direnv allow
```

or

```bash
nix develop
```

to activate the development environment, depending on if you
have [direnv](https://github.com/nix-community/nix-direnv)
installed or not.
