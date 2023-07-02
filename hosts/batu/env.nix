{ lib, pkgs, ... }:
{
  environment.variables = {
    EDITOR = "micro";
    NIX_BUILD_SHELL = "bash";
  };

  ## required for vs code remote
  environment.variables = {
    NIX_LD_LIBRARY_PATH =
      let
        forceValue = lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
        ];
      in
      lib.mkForce forceValue;
    NIX_LD =
      let
        contents = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
      in
      lib.mkForce contents;
  };

  # needed to get completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];




}


