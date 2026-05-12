{ pkgs, inputs, ... }:
pkgs.callPackage (
  {fishPlugins, lib}:
  fishPlugins.buildFishPlugin {
    pname = "direnv-shell-hooks";
    version = "0-unstable";

    src = lib.fileset.toSource {
      root = ../..;
      fileset = inputs.globset.lib.globs ../.. ["conf.d/_direnv-shell-hooks.fish"];
    };

    meta = {
      description = "A shell plugin that allows you to run shell-specific code when loading/unloading a direnv environment.";
      homepage = "https://github.com/bigolu/direnv-shell-hooks";
      license = lib.licenses.mit;
    };
  }
) {}
