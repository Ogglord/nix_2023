{ pkgs, lib, ... }:
{
  imports = [ ];

   # user friendly cli scripts
   home.file.".local/bin/shutdownmenu.sh".source = ./shutdownmenu.sh;
   home.file.".local/bin/rofi-op.sh".source = ./rofi-op.sh;

}