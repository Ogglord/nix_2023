{ pkgs, rofi-themes2, ... }:
{

  home.packages = [ rofi-themes2 ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    terminal = "alacritty";
    font = "Hack Nerd Font 14";
    theme = "${rofi-themes2}" + "/spotlight.rasi";
    #    font = "Ubuntu 16";
    extraConfig = {
      case-sensitive = false;
      show-icons = true;
      parse-hosts = true;
      modi = "window,drun,ssh,filebrowser,run";
    };
  };

}
