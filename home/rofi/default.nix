{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    terminal = "alacritty";
    font = "Hack Nerd Font 14";
#    font = "Ubuntu 16";
    extraConfig = {
      case-sensitive = false;
      show-icons = true;
      parse-hosts = true;
      modi = "window,drun,ssh,filebrowser,run";
    };
  };

}
