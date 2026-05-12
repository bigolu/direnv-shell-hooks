{ pkgs, ... }:
let
  inherit (pkgs) coreutils;
in
{
  imports = [
    # For extension "maximsmol.vscode-lsp-generic"
    {
      devshell.packages = with pkgs; [
        efm-langserver

        # efm-langserver launches commands with`sh`
        dash
        # These are used in the efm-langserver config
        actionlint
        markdownlint-cli2
        statix
        shellcheck
      ];
    }
  ];

  devshell.packages = with pkgs; [
    # For extension "jnoortheen.nix-ide"
    nixd
    # For extension "ndonfris.fish-lsp"
    fish-lsp
  ];
}
