{ pkgs, lib, inputs, ... }:
let
  #sworkstyle = inputs.sworkstyle.packages.x86_64-linux.sworkstyle;
  term = "alacritty";
  #menu = "wofi --show run";
  menu = "rofi -show drun -disable-history";
  #"${modifier}+d" = "exec rofi -show drun -disable-history";
  #"${modifier}+Shift+d" = "exec rofi -show run -disable-history";
in
{

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config =
      {
        modifier = "Mod4"; # windows key
        terminal = term;

        fonts = {
          names = [ "Ubuntu" ];
          size = 12.0;
        };
        bars = [ ];
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
          DP-2 = {
            scale = "1";
            adaptive_sync = "on";
          };
        };
        keybindings =
          let
            mod = "Mod4"; # windows key
          in
          {
            "${mod}+Return" = "exec ${term}";
            "${mod}+q" = "kill";
            "${mod}+d" = "exec ${menu}";
            "${mod}+p" = "exec tessen"; ## pwd manager
            #  	    "${modifier}+Shift+q" = "kill";
            #"${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
            "${mod}+Shift+e" = "exec /home/ogge/.local/bin/shutdownmenu.sh";

            "Mod1+tab" = "workspace next_on_output";
            "${mod}+tab" = "workspace next_on_output";
            "${mod}+Shift+tab" = "workspace prev_on_output";

            "${mod}+space" = "floating toggle";

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

        focus.newWindow = "smart";

        floating.criteria = [
          {
            title = "(?i)^(open|save|save as).?(workspace|file|directory|dir|new|.*\.{1}[a-z]{3}$|$)";
          }
          {
            app_id = "pavucontrol";
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
          {
            command = "mako";
          }
          {
            command = "sworkstyle & > /tmp/sworkstyle.log";
          }


          {
            command = "systemctl --user restart waybar ";
            always = true;
          }

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
          { command = "psst"; }
          {
            command = ''--no-startup-id
                  {
                    swaymsg "workspace 1; exec ${term};"
                  }
                ''
            ;
          }
          {
            command = ''--no-startup-id
                  {
                    systemctl --user restart waybar
                  }
                ''
            ;
            always = true;
          }


        ];

        assigns = {
          "number 2" = [{ app_id = "brave-browser"; }];
          "number 3" = [
            { app_id = "code"; }
          ];
          "number 4" = [
            { class = "steam"; }
            { app_id = "Steam"; }
            { title = "Steam"; }
          ];
          "number 10" = [{ app_id = "psst-gui"; }];
        };

      };
  };
}
