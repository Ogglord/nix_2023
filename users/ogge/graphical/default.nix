{ hostType, pkgs, ... }: {
  imports = [
    (
      if hostType == "nixos" || hostType == "homeManager" then ./sway
      else if hostType == "darwin" then ./darwin.nix
      else throw "Unknown hostType '${hostType}' for users/ogge/graphical"
    )
    ./mpv.nix
    ./code.nix
    ./mangohud
    #./steam.nix # not working in home-manager
  ];



  home.packages = with pkgs; [
    pavucontrol #sound control
    brave
    gopass
    libsecret
    polkit
    polkit_gnome
    vulkan-tools
    gnome.nautilus # best file explorer imho
    evince # document viewer (pdf etc.)
    libnotify
    #breeze-icons
    #breeze-gtk
    #wl-clipboard
    # wl-gammactl

    # xwayland # for legacy apps
    # waybar # configured as separate module
    #kanshi # autorandr
    # dmenu
    # wofi # replacement for dmenu
    #brightnessctl
    #gammastep # make it red at night!
    # sway-contrib.grimshot # screenshots
    # swayr #Swayr, a window-switcher & more for sway

    # https://discourse.nixos.org/t/some-lose-ends-for-sway-on-nixos-which-we-should-fix/17728/2?u=senorsmile
    #gnome3.adwaita-icon-theme # default gnome cursors
    #glib # gsettings
    #dracula-theme # gtk theme (dark)
    #gnome.networkmanagerapplet


    xdg-utils
  ] ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    authy
  ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    psst
  ];

  programs.alacritty.enable = true;

  # stylix.fonts = {
  #   sansSerif = {
  #     package = pkgs.ibm-plex;
  #     name = "IBM Plex Sans";
  #   };
  #   serif = {
  #     package = pkgs.ibm-plex;
  #     name = "IBM Plex Serif";
  #   };
  #   monospace = {
  #     package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
  #     name = "Hack Nerd Font";
  #   };
  #   emoji = {
  #     package = pkgs.noto-fonts-emoji;
  #     name = "Noto Color Emoji";
  #   };
  # };
}
