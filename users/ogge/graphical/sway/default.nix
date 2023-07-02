{ lib, pkgs, sworkstyle, ... }:
let
  sworkstyle-pkg = sworkstyle.packages.${pkgs.system}.sworkstyle;
in
{
  imports = [
    ./tessen.nix
    ./dunst.nix
    ./rofi.nix
    ./sway.nix
    ./kanshi.nix
    ./waybar.nix
  ];



  home = {
    packages = with pkgs; [
      grim ## screenshots
      imv ## image viewer
      slurp ## select part of screen (works with grim)
      swaybg ## change wallpaper
      swayidle
      sworkstyle
      sworkstyle-pkg
      wl-clipboard
      #wl-gammactl
      xwayland
    ];
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  ## force brave to wayland mode
  home.file.".config/brave-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';
  ## copy our screenshot script
  home.file.".local/bin/screenshot".source = ./static/screenshot.sh;
  home.file.".local/bin/screenshot".executable = true;

  programs = {
    swaylock = {
      enable = true;
      settings = {
        indicator-caps-lock = true;
        scaling = "fill";
        show-failed-attempts = true;
      };
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${lib.getExe pkgs.swaylock} -f"; }
      { event = "lock"; command = "${lib.getExe pkgs.swaylock} -f"; }
    ];
    timeouts = [
      { timeout = 230; command = ''${lib.getExe pkgs.libnotify} -t 30000 -- "Screen will lock in 30 seconds"''; }
      { timeout = 300; command = "${lib.getExe pkgs.swaylock} -f"; }
      {
        timeout = 600;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "image/bmp" = lib.mkForce "imv.desktop";
    "image/gif" = lib.mkForce "imv.desktop";
    "image/jpeg" = lib.mkForce "imv.desktop";
    "image/jpg" = lib.mkForce "imv.desktop";
    "image/pjpeg" = lib.mkForce "imv.desktop";
    "image/png" = lib.mkForce "imv.desktop";
    "image/tiff" = lib.mkForce "imv.desktop";
    "image/x-bmp" = lib.mkForce "imv.desktop";
    "image/x-pcx" = lib.mkForce "imv.desktop";
    "image/x-png" = lib.mkForce "imv.desktop";
    "image/x-portable-anymap" = lib.mkForce "imv.desktop";
    "image/x-portable-bitmap" = lib.mkForce "imv.desktop";
    "image/x-portable-graymap" = lib.mkForce "imv.desktop";
    "image/x-portable-pixmap" = lib.mkForce "imv.desktop";
    "image/x-tga" = lib.mkForce "imv.desktop";
    "image/x-xbitmap" = lib.mkForce "imv.desktop";
  };
}
