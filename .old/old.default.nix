{ config, pkgs, nil, ... }:
let
  colorscheme = import ./colors.nix;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  
  home.username = "ogge";
  home.homeDirectory = "/home/ogge";
  fonts.fontconfig.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

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
  
 

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  home.packages = with pkgs; [                               
    htop
    fortune
    exa
    oh-my-zsh
    neofetch
    micro
    mako 
    brave
    breeze-icons
    breeze-gtk
    swaylock
    swayidle
    wl-clipboard
    alacritty
    wofi
    spotify
    authy
    ## fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
    roboto # serif default
    ubuntu_font_family # sans-serif default
  ];

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  ## programs

  wayland.windowManager.sway = {
  	enable = true;
  	wrapperFeatures.gtk = true;
  	config = {
  	  modifier = "Mod4"; # windows key
      terminal = "alacritty";
  	  menu = "wofi --show run";

  	  
  	  fonts = {
            names = [ "Ubuntu" ];
            size = 12.0;
          };
       bars = [];
  	#  bars = [{
  	#    fonts.size = 14.0;
  	#  	position = "bottom";
  	#  	extraConfig = ''
  	#  	            separator_symbol "  "
  	#  	            wrap_scroll no
  	#  	          '';
  	#  }];	
      input = {
        "*" = { 
          xkb_layout = "se"; 
#          xkb_options = "";
        };
      };
      gaps = {
        inner = 20;
        smartGaps = true;
      };
      
  	  output = {
  	  	eDP-1 = {
  	  	  scale = "1";	
  	  	};
  	  };
   	  keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        inherit (config.wayland.windowManager.sway.config)
          menu terminal;
  	  in
  	  {
  	    "${mod}+Return" = "exec ${terminal}";
        "${mod}+q" = "kill";
        "${mod}+d" = "exec ${menu}";
#  	    "${modifier}+Shift+q" = "kill";
  	    #"${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
  	    "Mod1+tab" = "workspace next_on_output";
  	    "${mod}+tab" = "workspace next_on_output";
		"${mod}+Shift+tab" = "workspace prev_on_output";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

		"${mod}+1" = "workspace number 1";
		"${mod}+2" = "workspace number 2";
		"${mod}+3" = "workspace number 3";
		"${mod}+4" = "workspace number 4";
		"${mod}+5" = "workspace number 5";
		"${mod}+6" = "workspace number 6";
		"${mod}+7" = "workspace number 7";
		"${mod}+8" = "workspace number 8";
		"${mod}+9" = "workspace number 9";
		"${mod}+0" = "workspace number 10";

		"${mod}+Shift+1" = "move container to workspace number 1";
		"${mod}+Shift+2" = "move container to workspace number 2";
		"${mod}+Shift+3" = "move container to workspace number 3";
		"${mod}+Shift+4" = "move container to workspace number 4";
		"${mod}+Shift+5" = "move container to workspace number 5";
		"${mod}+Shift+6" = "move container to workspace number 6";
		"${mod}+Shift+7" = "move container to workspace number 7";
		"${mod}+Shift+8" = "move container to workspace number 8";
		"${mod}+Shift+9" = "move container to workspace number 9";
		"${mod}+Shift+0" = "move container to workspace number 10";
  	  };

  	   window.commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "brave-browser";
          }
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "mpv";
          }
          {
            command = "inhibit_idle fullscreen";
            criteria.class = "Spotify";
          }
          {
            # spotify doesn't set its WM_CLASS until it has mapped, so the assign is not reliable
            command = "move to workspace 10";
            criteria.class = "Spotify";
          }
          {
            command = "move to scratchpad";
            criteria = {
              app_id = "org.keepassxc.KeePassXC";
              title = "^Passwords.kdbx";
            };
          }
        ];

  	   startup = [
  	      #{ command = "systemctl --user restart waybar"; always = true; }
          { command = "brave"; }
          { command = "authy"; }
          #{
          #  command =
          #    let lockCmd = "'swaylock -f -i \"\$(${wallpaper}/bin/wallpaper get)\"'";
          #    in
          #    ''swayidle -w \
          #    timeout 600 ${lockCmd} \
          #    timeout 1200 'swaymsg "output * dpms off"' \
          #    resume 'swaymsg "output * dpms on"' \
          #    before-sleep ${lockCmd}
        #'';
        #  }
          { command = "code"; }
          { command = "spotify"; }
          { command = "move to workspace 1"; }
          { command = "Alacritty"; }

        ];

        assigns = {
          "2" = [{ class = "brave-browser"; }];
          "3" = [
            { app_id = "code"; }
            { app_id = "Slack"; }
            { app_id = "Steam"; }
          ];
          "10" = [{ app_id = "Spotify"; }];
        };

  	};
  };

  programs.waybar = {
    enable = true;
    style = ./waybar_style.css;
    systemd.enable = true;

    settings = {
      mainBar = {
        "layer" = "top";
        "position" = "bottom";
        "height" = 30;
        "modules-left" = [
          "sway/workspaces"
          "custom/right-arrow-dark"
        ];
        "modules-center" = [
          "custom/left-arrow-dark"
          "clock#1"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "clock#2"
          "custom/right-arrow-dark"
          "custom/right-arrow-light"
          "clock#3"
          "custom/right-arrow-dark"
        ];
        "modules-right" = [
          "custom/left-arrow-dark"
          "pulseaudio"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "memory"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "cpu"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "network"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
#          "battery"
#          "custom/left-arrow-light"
#          "custom/left-arrow-dark"
#          "custom/left-arrow-light"
#          "custom/left-arrow-dark"
          "backlight"
          "tray"
        ];

        "custom/left-arrow-dark" = {
          "format" = "";
          "tooltip" = false;
        };
        "custom/left-arrow-light" = {
          "format" = "";
          "tooltip" = false;
        };
        "custom/right-arrow-dark" = {
          "format" = "";
          "tooltip" = false;
        };
        "custom/right-arrow-light" = {
          "format" = "";
          "tooltip" = false;
        };

        "sway/workspaces" = {
          "disable-scroll" = true;
          "format" = "{name}";
        };

        "clock#1" = {
          "format" = "{:%a}";
          "tooltip" = false;
        };
        "clock#2" = {
          "format" = "{:%H:%M}";
          "tooltip" = false;
        };
        "clock#3" = {
          "format" = "{:%m-%d}";
          "tooltip" = false;
        };

        "pulseaudio" = {
          "format" = "{icon} {volume:2}%";
          "format-bluetooth" = "{icon}  {volume}%";
          "format-muted" = "MUTE";
          "format-icons" = {
            "headphones" = "";
            "default" = [
              ""
              ""
            ];
          };
          "scroll-step" = 5;
          "on-click" = "pavucontrol";
          "on-click-right" = "pamixer -t";
        };
        "memory" = {
          "interval" = 5;
          "format" = "Mem {}%";
        };
        "cpu" = {
          "interval" = 5;
          "on-click" = "emacsclient -c -e '(proced)'";
          "format" = "CPU {usage:2}%";
        };
        "battery" = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "tray" = {
          "icon-size" = 20;
        };
        "network" = {
          "interface" = "wlp11s0";
          "format" = "{ifname}";
          "format-wifi" = "({signalStrength}%) ";
          "format-ethernet" = "Connected ";
          "format-disconnected" = "";
          "tooltip-format" = "{ifname}";
          "tooltip-format-wifi" = "{ipaddr} @ {essid}";
          "tooltip-format-ethernet" = "{ipaddr} ";
          "tooltip-format-disconnected" = "Disconnected";
          "on-click" = "emacsclient -c -e '(view-file \"~/Documents/tech-personal-notes/nmcli-help.org\")'";
          "max-length" = 100;
        };
        "backlight" = {
              "device" = "intel_backlight";
                "format" = "{percent}% {icon}";
              "format-icons" = ["" ""];	
        };
      };
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

  #programs.alacritty = 
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
      bbenoist.nix
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "window.zoomLevel" = 1;
      "workbench.colorTheme" = "Dracula";
      "nix.enableLanguageServer" = true;
    };
  };
  
  programs.zsh = {
	enable = true;
	shellAliases = {
      la = "ls -al";
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;	
      plugins = [ "git" "sudo"];
      theme = "robbyrussell";
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


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
