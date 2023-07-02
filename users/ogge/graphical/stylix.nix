{ config, lib, pkgs, stylix, ... }:
let
  schemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "9a4002f78dd1094c123169da243680b2fda3fe69";
    sha256 = "sha256-AngNF++RZQB0l4M8pRgcv66pAcIPY+cCwmUOd+RBJKA=";
  };
in
{
  #   stylix = {
  #     base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  #     # We need this otherwise the autoimport clashes with our manual import.
  #     homeManagerIntegration.autoImport = false;
  #     # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
  #     image = pkgs.fetchurl {
  #       url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
  #       hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
  #     };
  #   };

  stylix = {
    #homeManagerIntegration.followSystem = false;
    #    image = pkgs.fetchurl {
    #        url = "https://dl.dropboxusercontent.com/s/26outp2w90fw4bl/ffxiv-wallpaper.jpg?dl=0";
    #        sha256 = "I8vEvC2R68ToXDLD/ZYK93NXpxeWw84btX7Spfajuec=";
    #    };
    # wallpaper = config.lib.stylix.mkAnimation {
    #   animation = ./sway/static/gif/bg_biker.gif;
    #   polarity = "dark";
    #   override = {
    #     #             base00 = "ffffff";
    #   };
    # };
    #image = ../../resources/static/log-horizon.jpg;
    #override = {
    #    base00 = "ffffff";
    #    base01 = "ffffff";
    #    base02 = "ffffff";
    #    base03 = "ffffff";
    #    base04 = "ffffff";
    #    base05 = "ffffff";
    #    base06 = "ffffff";
    #    base07 = "ffffff";
    #    base08 = "ffffff";
    #    base09 = "ffffff";
    #    base0A = "ffffff";
    #    base0B = "ffffff";
    #    base0C = "ffffff";
    #    base0D = "ffffff";
    #    base0E = "ffffff";
    #    base0F = "ffffff";
    #};
    image = ./sway/static/gif/bg_biker.gif;
    fonts = {

      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "IBM Plex Sans"; ## Skip "Serif"
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        desktop = lib.mkForce 16;
        applications = lib.mkForce 14;
        terminal = lib.mkForce 11;
        popups = lib.mkForce 15;
      };
    };
    # heetch
    # gruvbox-material-light-hard
    # catppuccin-frappe.yaml
    # primer-dark-dimmed
    # https://tinted-theming.github.io/base16-gallery/
    base16Scheme = "${schemes}/solarized-dark.yaml";
    polarity = "dark";
    opacity = {
      terminal = 0.90;
      applications = 0.90;
      popups = 0.50;
      desktop = 0.90;
    };
    targets = {
      waybar.enable = lib.mkForce false;
      vscode.enable = lib.mkForce false;
      sway.enable = lib.mkForce true;
    };
  };
}
 