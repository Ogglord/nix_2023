{ lib, pkgs, ... }:
{
  systemd.user.services.waybar.Service.Restart = lib.mkForce "always";

  programs.waybar = {
    enable = true;
    #style = ../static/waybar_style.css;
    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = {
      mainBar = {
        "layer" = "top";
        "position" = "top";
        "height" = 33;
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
          "format-icons" = [ "" "" ];
        };
      };
    };
  };
}
