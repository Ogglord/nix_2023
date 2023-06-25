{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    terminal = "alacritty";

  };

}
