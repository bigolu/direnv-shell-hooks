# direnv-shell-hooks
A shell plugin that allows you to run shell-specific code when loading/unloading a direnv environment. Based on this PR: https://github.com/direnv/direnv/pull/1565

## Installation

### fish

#### [fisher][fisher]

Run `fisher install bigolu/direnv-shell-hooks`

#### Nix (flake)

Example `flake.nix`:

```nix
  {
    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      direnv-shell-hooks = {
        url = "github:bigolu/direnv-shell-hooks";
        inputs = {
          nixpkgs.follows = "nixpkgs";

          # Remove development dependencies
          devshell.follows = "";
          flake-compat.follows = "";
          devshell-modules.follows = "";
        };
      };
    };

    outputs = inputs:
      let
        # You can use the package
        package = inputs.direnv-shell-hooks.packages.${system}.fish;
        # Or the overlay
        packageFromOverlay = (import inputs.nixpkgs { overlays = [inputs.direnv-shell-hooks.overlays.default]; }).fishPlugins.direnv-shell-hooks;
      in
      {
        ...
      }
  }
```

[fisher]: https://github.com/jorgebucaran/fisher