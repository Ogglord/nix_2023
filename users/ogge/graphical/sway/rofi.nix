{ pkgs, ... }:
{

  home.packages = with pkgs; [ rofi-themes2 ];
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    location = "center";
    terminal = "alacritty";
    font = "Hack Nerd Font 14";
    theme = "${pkgs.rofi-themes2}" + "/spotlight.rasi";
    #    font = "Ubuntu 16";
    extraConfig = {
      case-sensitive = false;
      show-icons = true;
      parse-hosts = true;
      modi = "window,drun,ssh,filebrowser,run";
    };
  };

}
