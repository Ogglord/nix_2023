{ pkgs, lib, inputs, ... }:
let
  #sworkstyle = inputs.sworkstyle.packages.x86_64-linux.sworkstyle;
  term = "alacritty";
  #menu = "wofi --show run";
  menu = "rofi -show drun -disable-history";


in
{
  ## shutdown menu script
  home.file.".local/bin/shutdownmenu.sh".source = ./static/shutdownmenu.sh;
  home.file.".local/bin/shutdownmenu.sh".executable = true;
  ## sworkstyle config - map applications to workspace icons in sway
  #home.file.".config/sworkstyle/config.toml".source = ./static/sworkstyle_config.toml;

  wayland.windowManager.sway = {

    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraConfigEarly = ''
      rename $ws0 "0: General"
      rename $ws1 "1: Shell"
      rename $ws2 "2: Dev"
      rename $ws3 "3: Web"
      rename $ws4 "4: Music"
      rename $ws5 "5: Mail"
      rename $ws6 "6: Urgent"
      rename $ws7 "7: Focused"
      rename $ws8 "8"
      rename $ws9 "9"
      rename $ws10 "10"
    '';
    extraConfig = ''
      shadows enable
      corner_radius 5
      set $ws0 "0: General"
      set $ws1 "1: Shell"
      set $ws2 "2: Dev"
      set $ws3 "3: Web"
      set $ws4 "4: Music"
      set $ws5 "5: Mail"
      set $ws6 "6: Urgent"
      set $ws7 "7: Focused"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"
      default_border pixel 4   
      default_floating_border pixel 4
      for_window [urgent="latest"] focus
      focus_follows_mouse yes
      focus_on_window_activation urgent

    '';
    config =
      {
        modifier = "Mod4"; # windows key
        terminal = term;
        workspaceAutoBackAndForth = true;
        defaultWorkspace = "workspace number 1";
        fonts.size = lib.mkForce 14.0;
        focus.newWindow = "focus";
        gaps = {
          inner = 20;
          smartGaps = false;
        };

        bars = [ ];
        input = {
          "*" = {
            xkb_layout = "se";
          };
        };
        output = {
          DP-2 = {
            mode = "2560x1440@240Hz";
            pos = "0 0";
            scale = "1";
            adaptive_sync = "on";
            dpms = "on";
          };
        };

        keybindings =
          let
            # alt = Mod1 (keycode -1 according to libinput and my current varmilo keyboard)
            # win = Mod4 (keycode 125)
            mod = "Mod4"; # windows key keycode=125
          in
          {
            "${mod}+Return" = ''exec "${term}" '';
            "${mod}+q" = "kill";
            "${mod}+space" = "exec ${menu}";
            "${mod}+p" = "exec tessen"; ## pwd manager
            "Print" = "exec /home/ogge/.local/bin/screenshot"; ## print screen

            #  	    "${modifier}+Shift+q" = "kill";
            #"${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
            "${mod}+Shift+e" = "exec /home/ogge/.local/bin/shutdownmenu.sh";

            "Mod1+tab" = "workspace next_on_output";
            "${mod}+tab" = "workspace back_and_forth";
            "${mod}+Shift+tab" = "workspace prev_on_output";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "reload";
            "Scroll_Lock" = ''exec alacritty -t "Building system..." --class floating -e "$(which zsh)" -c "pushd /home/ogge/nix;pwd;sudo nixos-rebuild build --flake '.#';popd;echo Closing in 3;sleep 1;echo 2;sleep 1;echo 1;sleep 1;exit"'';
            "Pause" = ''exec alacritty -t "Switching system..." --class floating -e "$(which zsh)" -c "pushd /home/ogge/nix;pwd;sudo nixos-rebuild switch --flake '.#';popd;echo Closing in 3;sleep 1;echo 2;sleep 1;echo 1;sleep 1;exit"'';

            "${mod}+f" = "floating toggle";

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

        modes = {
          "system:  [r]eboot  [p]oweroff  [l]ogout" = {
            r = "exec reboot";
            p = "exec poweroff";
            l = "exit";
            Return = "mode default";
            Escape = "mode default";
          };
        };



        floating.criteria = [
          {
            title = "(?i)^(open|save|save as).?(workspace|file|directory|dir|new|.*\.{1}[a-z]{3}$|$)";
          }
          {
            app_id = "pavucontrol";
          }
          {
            app_id = "floating";
          }
          {
            window_role = "pop-up";
          }
          {
            window_role = "bubble";
          }
          {
            window_role = "dialog";
          }
          {
            window_role = "menu";
          }
          {
            window_role = "task_dialog";
          }
          {
            window_type = "dialog";
          }
          {
            window_type = "menu";
          }
          {
            title = "Friends List";
          }


        ];
        window.commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "brave-browser ";
          }
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "mpv ";
          }
          {
            command = "inhibit_idle fullscreen";
            criteria.class = "Spotify ";
          }
          {
            # spotify doesn't set its WM_CLASS until it has mapped, so the assign is not reliable
            command = "move to workspace 10";
            criteria.class = "Spotify";
          }
          # {
          #   command = "
        ];
        startup = [
          # FYI: exec is implied here, for each command
          # {
          #   command = "mako";
          # }
          # {
          #   command = "sworkstyle & > /tmp/sworkstyle.log";
          # }


          # {
          #   command = "systemctl --user reload-or-restart waybar ";
          #   always = true;
          # }

          # {
          #   command = "systemctl --user reload-or-restart kanshi ";
          #   always = true;
          # }

          {
            command = "brave";
          }

          #{
          #  command =
          #    let lockCmd = "
          #swaylock - f - i \"\$(${wallpaper}/bin/wallpaper get)\"'";
          #    in
          #    ''swayidle -w \
          #    timeout 600 ${lockCmd} \
          #    timeout 1200 'swaymsg "output * dpms off"' \
          #    resume 'swaymsg "output * dpms on"' \
          #    before-sleep ${lockCmd}
          #'';
          #  }
          {
            command = "code";
          }
          # { command = "psst"; }
          {
            command = ''--no-startup-id
                  {
                    swaymsg "workspace $ws1; exec ${term};"
                  }
                ''
            ;
          }
          #{
          #   command = ''--no-startup-id
          #         {
          #           systemctl --user restart waybar
          #         }
          #       ''
          #   ;
          #   always = true;
          # }


        ];

        assigns = {
          "number 2" = [{ app_id = "brave-browser"; }];
          "number 3" = [
            { app_id = "code"; }
            #{ window_class = "Code"; }
            { class = "Code"; }
          ];
          "number 4" = [
            { class = "steam"; }
            { app_id = "Steam"; }
            { title = "Steam"; }
          ];
          "number 10" = [{ app_id = "psst-gui"; }];
        };

      };

    swaynag.enable = true;
    swaynag.settings = {
      "<config>" = {
        edge = "top";
        layer = "overlay";
        font = "IBM Plex Sans 12";
        button-padding = 6;
        button-gap = 10;
        button-margin-right = 4;
        button-dismiss-gap = 6;
        details-border-size = 2;
        button-border-size = 0;
        border-bottom-size = 2;

      };

      error = {
        background = "960019";
        text = "FFFFFF";
        button-background = "31363b";
        message-padding = 10;
      };
      warning = {
        background = "d6b85a";
        text = "000000";
        button-background = "ffffff";
        message-padding = 10;
      };
    };
  };
}
