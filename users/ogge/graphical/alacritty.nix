{ pkgs, lib, config, ... }:
with lib; {

  programs.alacritty = optionals config.programs.alacritty.enable {
    settings = {
      color_schemes = import ./alacritty_colorschemes { };
      colors = {

        # Default colors
        primary = {
          background = "#1E1E2E"; # base
          foreground = "#CDD6F4"; # text
          # Bright and dim foreground colors
          dim_foreground = "#CDD6F4"; # text
          bright_foreground = "#CDD6F4"; # text
        };
        # Cursor colors
        cursor = {
          text = "#1E1E2E"; # base
          cursor = "#F5E0DC"; # rosewater
        };
        vi_mode_cursor = {
          text = "#1E1E2E"; # base
          cursor = "#B4BEFE"; # lavender
        };
        # Search colors
        search = {
          matches = {
            foreground = "#1E1E2E"; # base
            background = "#A6ADC8"; # subtext0
          };
          focused_match = {
            foreground = "#1E1E2E"; # base
            background = "#A6E3A1"; # green
          };
          footer_bar = {
            foreground = "#1E1E2E"; # base
            background = "#A6ADC8"; # subtext0
          };

          # Keyboard regex hints
          hints = {
            start = {
              foreground = "#1E1E2E"; # base
              background = "#F9E2AF"; # yellow
            };
            end = {
              foreground = "#1E1E2E"; # base
              background = "#A6ADC8"; # subtext0
            };
          };

          # Selection colors
          selection = {
            text = "#1E1E2E"; # base
            background = "#F5E0DC"; # rosewater
          };

          # Normal colors
          normal = {
            black = "#45475A"; # surface1
            red = "#F38BA8"; # red
            green = "#A6E3A1"; # green
            yellow = "#F9E2AF"; # yellow
            blue = "#89B4FA"; # blue
            magenta = "#F5C2E7"; # pink
            cyan = "#94E2D5"; # teal
            white = "#BAC2DE"; # subtext1
          };

          # Bright colors
          bright = {
            black = "#585B70"; # surface2
            red = "#F38BA8"; # red
            green = "#A6E3A1"; # green
            yellow = "#F9E2AF"; # yellow
            blue = "#89B4FA"; # blue
            magenta = "#F5C2E7"; # pink
            cyan = "#94E2D5"; # teal
            white = "#A6ADC8"; # subtext0
          };

          # Dim colors
          dim = {
            black = "#45475A"; # surface1
            red = "#F38BA8"; # red
            green = "#A6E3A1"; # green
            yellow = "#F9E2AF"; # yellow
            blue = "#89B4FA"; # blue
            magenta = "#F5C2E7"; # pink
            cyan = "#94E2D5"; # teal
            white = "#BAC2DE"; # subtext1
          };

          indexed_colors =
            [
              { index = 16; color = "#FAB387"; }
              { index = 17; color = "#F5E0DC"; }
            ];
        };
      };
      #window = {
      #  opacity = 0.9;
      #};
      font = {
        normal = {
          family = "Iosevka Nerd Font Mono";
          style = "Regular";
        };
        size = "10";
      };
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        #args = [
        #  "-l"
        #  "-c"
        #  "tmux attach || tmux"
        #];
      };
    };
  };

  #  programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     window.padding.x = 15;
  #     window.padding.y = 15;
  #     window.decorations = "None";
  #     window.dynamic_title = true;
  #     scrolling.history = 100000;
  #     live_config_reload = true;
  #     selection.save_to_clipboard = true;
  #     mouse.hide_when_typing = true;
  #     use_thin_strokes = true;

  #     font = {
  #       size = 12;
  #       normal.family = "Hack Nerd Font";
  #     };

  #     colors = {
  #       cursor.cursor = "#81a1c1";
  #       primary.background = "#2e3440";
  #       primary.foreground = "#d8dee9";

  #       normal = {
  #         black = "#3b4252";
  #         red = "#bf616a";
  #         green = "#a3be8c";
  #         yellow = "#ebcb8b";
  #         blue = "#81a1c1";
  #         magenta = "#b48ead";
  #         cyan = "#88c0d0";
  #         white = "#e5e9f0";
  #       };

  #       bright = {
  #         black = "#4c566a";
  #         red = "#bf616a";
  #         green = "#a3be8c";
  #         yellow = "#ebcb8b";
  #         blue = "#81a1c1";
  #         magenta = "#b48ead";
  #         cyan = "#8fbcbb";
  #         white = "#eceff4";
  #       };
  #     };


  #     key_bindings = [
  #       # { key = "V"; mods = "Control"; action = "Paste"; }
  #       # { key = "C"; mods = "Control"; action = "Copy"; }
  #       # { key = "Q"; mods = "Command"; action = "Quit"; }
  #       # { key = "Q"; mods = "Control"; chars = "\\x11"; }
  #       #     { key = "F"; mods = "Alt"; chars = "\\x1bf"; }
  #       #     { key = "B"; mods = "Alt"; chars = "\\x1bb"; }
  #       #     { key = "D"; mods = "Alt"; chars = "\\x1bd"; }
  #       #    { key = "Key3"; mods = "Alt"; chars = "#"; }
  #       #     { key = "Slash"; mods = "Control"; chars = "\\x1f"; }
  #       #     { key = "Period"; mods = "Alt"; chars = "\\e-\\e."; }
  #       #     {
  #       #       key = "N";
  #       #       mods = "Command";
  #       #       command = {
  #       #         program = "open";
  #       #         args = [ "-nb" "io.alacritty" ];
  #       #       };
  #       #     }
  #     ];
  #   };
  # };
}
