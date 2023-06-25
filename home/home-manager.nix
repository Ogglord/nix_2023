{ inputs, lib, config, pkgs, system, ... }:
let
  sworkstyle = inputs.sworkstyle.packages.x86_64-linux.sworkstyle;
  colorscheme = import ./colors.nix;
in
{
  # You can import other home-manager modules here, or flakes
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./zsh
    ./sway
    ./waybar
    #./wofi
    ./rofi
    ./vscode
    ./static_files
    ./tessen
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      (final: prev: {
        rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs
          (old: {
            src = prev.fetchFromGitHub {
              owner = "lbonn";
              repo = "rofi";
              rev = "d06095b5ed40e5d28236b7b7b575ca867696d847";
              fetchSubmodules = true;
              sha256 = "0qdp46d8wn3jp57hwj710709drl3dlrjxb8grfmfa6a5lnjwg1zh";
            };
            version = "1.7.6+wayland1-git";
          });
      })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "ogge";
    homeDirectory = "/home/ogge";
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
  };

  home.file.".local/bin/pass".source = config.lib.file.mkOutOfStoreSymlink "/home/ogge/.nix-profile/bin/gopass";

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    _1password
    alacritty
    authy
    brave
    breeze-icons
    breeze-gtk
    exa
    #fuzzel
    #rofi-wayland-unwrapped
    fortune
    gopass ## password manager backend
    libnotify
    libsecret
    neofetch
    micro
    mako
    pavucontrol
    pinentry-rofi
    psst
    spotify
    swaylock
    swayidle
    sworkstyle
    htop
    wl-clipboard
    wl-gammactl
    #wofi

    ## fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
    roboto # serif default
    ubuntu_font_family # sans-serif default
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze-Dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  ## wayland notification daemon
  services.mako = {
    enable = true;
    backgroundColor = "#${colorscheme.light.green}e6"; # 90%
    textColor = "#${colorscheme.light.fg_1}";
    borderColor = "#${colorscheme.light.fg_0}";
    font = "sans-serif";
    #extraConfig = ''
    #  [mode=dnd]
    #  invisible=1
    #'';
  };

  programs.git = {
    enable = true;
    # Additional options for the git program
    package = pkgs.gitAndTools.gitFull; # Install git wiith all the optional extras
    userName = "ogglord";
    userEmail = "oag@proton.me";
    extraConfig = {
      # Use vim as our default git editor
      core.editor = "nano";
      # Cache git credentials for 15 minutes
      credential.helper = "cache";
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
