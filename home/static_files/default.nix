{ pkgs, lib, ... }:
{
  imports = [ ];

  # user friendly cli scripts
  ## shutdown menu

  home.file.".local/bin/shutdownmenu.sh".source = ./shutdownmenu.sh;

  ## map applications to icons in sway
  home.file.".config/sworkstyle/config.toml".source = ./sworkstyle_config.toml;

  ## set default apps (browser, file explorer, etc.)
  home.file.".config/mimeapps.list".source = ./mimeapps.list;

  ## help command
  home.file.".local/bin/help".source = ./rofi-op.sh;

}
