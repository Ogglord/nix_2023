{ pkgs, lib, ... }:
{
  imports = [ ];

  # user friendly cli scripts
  home.file.".local/bin/shutdownmenu.sh".source = ./shutdownmenu.sh;
  home.file.".local/bin/rofi-op.sh".source = ./rofi-op.sh;
  home.file.".config/sworkstyle/config.toml".source = ./sworkstyle_config.toml;

}
