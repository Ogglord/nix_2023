{ pkgs, ... }: {

  imports = [
    ./greetd.nix
    ./sway.nix

  ];

  # silent boot for plymouth
  boot = {
    ## qiet boot please
    #plymouth.enable = true;
    #plymouth.theme = "breeze";
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" "udev.log_level=3" ]; #"rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
  };



  # Configure keymap in X11
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";


  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = "auth include login";
  };
  services.gnome.gnome-keyring = {
    enable = true;
  };

  #stylix.targets.plymouth.enable = false;
  #stylix.targets.gnome.enable = true;

  programs.dconf.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # needed for GUI apps to escalate to sudo
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };


}

