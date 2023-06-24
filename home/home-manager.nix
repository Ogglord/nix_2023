{ inputs, lib, config, pkgs, system, nixosConfig, sworkstyle, ... }: 
let
 inherit (nixosConfig.system) stateVersion sworkstyle;
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
    ./wofi
    ./scripts
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

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    _1password  
    alacritty
    authy
    brave
    breeze-icons
    breeze-gtk                             
    exa
    fortune   
    libnotify
    libsecret
    neofetch
    micro
    mako    
    pavucontrol
    pinentry-rofi
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


  programs.alacritty = {
    enable = true;
    settings = {
      window.padding.x = 15;
      window.padding.y = 15;
      window.decorations = "None";
      window.dynamic_title = true;
      scrolling.history = 100000;
      live_config_reload = true;
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
      use_thin_strokes = true;

      font = {
        size = 12;
        normal.family = "Hack Nerd Font";
      };

      colors = {
        cursor.cursor = "#81a1c1";
        primary.background = "#2e3440";
        primary.foreground = "#d8dee9";

        normal = {
          black = "#3b4252";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#88c0d0";
          white = "#e5e9f0";
        };

        bright = {
          black = "#4c566a";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#8fbcbb";
          white = "#eceff4";
        };
      };


      key_bindings = [
      # { key = "V"; mods = "Control"; action = "Paste"; }
      # { key = "C"; mods = "Control"; action = "Copy"; }
      # { key = "Q"; mods = "Command"; action = "Quit"; }
      # { key = "Q"; mods = "Control"; chars = "\\x11"; }
  #     { key = "F"; mods = "Alt"; chars = "\\x1bf"; }
  #     { key = "B"; mods = "Alt"; chars = "\\x1bb"; }
  #     { key = "D"; mods = "Alt"; chars = "\\x1bd"; }
  #    { key = "Key3"; mods = "Alt"; chars = "#"; }
  #     { key = "Slash"; mods = "Control"; chars = "\\x1f"; }
  #     { key = "Period"; mods = "Alt"; chars = "\\e-\\e."; }
  #     {
  #       key = "N";
  #       mods = "Command";
  #       command = {
  #         program = "open";
  #         args = [ "-nb" "io.alacritty" ];
  #       };
  #     }
      ];
    };
  };
      
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      #bbenoist.nix
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "window.zoomLevel" = 1;
      "workbench.colorTheme" = "Dracula";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {    
        "nil" = {
          "diagnostics" = {
            "ignored" = [ "unused_binding" "unused_with" ];
          };
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
    };
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
