{ lib, pkgs, ... }:
{
  environment.variables = {
    EDITOR = "micro";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    NIX_BUILD_SHELL = "zsh";
  };

  # needed to get completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.shellAliases = { rofi = "wofi"; };
  
}


