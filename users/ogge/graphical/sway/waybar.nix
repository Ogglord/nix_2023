{ lib, pkgs, ... }:
{
  systemd.user.services.waybar.Service.Restart = lib.mkForce "always";
  #options.stylix.targets.waybar.enableCenterBackColors = true;

  programs.waybar = {
    enable = true;
    #style = ../static/waybar_style.css;
    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = {
      mainBar = {
        "layer" = "top";
        "position" = "top";
        "height" = 40;
        "modules-left" = [
          "sway/workspaces"
        ];
        "modules-center" = [
          "sway/window"

        ];
        "modules-right" = [
          "tray"
          "wireplumber"
          "network"
          "clock"
        ];

        "sway/workspaces" = {
          "disable-scroll" = true;
          "format" = "{name}";
        };

        "sway/window" = {
          "format" = "{title}";
          "max-length" = 50;
          "all-outputs" = true;
          "rewrite" = {
            "(.*) - Brave" = "🌎 $1";
            "(.*)Alacritty$" = " [$1]";
            "(.*) - zsh" = " [$1]";
          };
        };

        "clock" = {
          "format" = "{:%H:%M}  ";
          "format-alt" = "{:%A, %B %d, %Y (%R)}  ";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "left";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        "wireplumber" = {
          "format" = "{volume}% {icon}";
          "format-muted" = "";
          "on-click" = "helvum";
          "format-icons" = [ "" "" "" ];
          "max-volume" = 150;
          "scroll-step" = 0.2;
        };

        "pulseaudio" = {
          "format" = "{icon}  {volume:2}%";
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

        "tray" = {
          "icon-size" = 20;
        };
        "network" = {
          "interface" = "wlp11s0";
          "format" = "{ifname}";
          "format-wifi" = "  {signalStrength}%";
          "format-ethernet" = "Connected ";
          "format-disconnected" = "";
          "tooltip-format" = "{ifname}";
          "tooltip-format-wifi" = "{ipaddr} @ {essid}";
          "tooltip-format-ethernet" = "{ipaddr} ";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 100;
        };

      };
    };
  };
}
