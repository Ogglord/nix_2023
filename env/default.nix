{ lib, pkgs, ... }:
{
  environment.variables = {
    EDITOR = "micro";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    NIX_BUILD_SHELL = "zsh";
  };

  # needed to get completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";

    NIXOS_OZONE_WL = "1";
  };


}


