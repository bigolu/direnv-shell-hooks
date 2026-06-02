{ perSystem, inputs, ... }:
perSystem.devshell.mkShell (
  { extraModulesPath, ... }:
  {
    imports = [
      "${extraModulesPath}/locale.nix"
      ./modules/vscode.nix
    ]
    ++ (with inputs.devshell-modules.devshellModules; [
      minimal
      autocomplete
      state
      gcRoot
    ]);

    gcRoot.roots.flake.inputs = inputs;
  }
)
