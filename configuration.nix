{ config, pkgs, lib, inputs, unstable, ... }:
let
  sworkstyle = inputs.sworkstyle.packages.x86_64-linux.sworkstyle;
in
{
  imports =
    [
      ./env
      ./hardware/desktop.nix
      ./system-packages
      ./system-packages/fonts
      ./system-packages/greetd
      ./system-packages/steam
    ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  time.timeZone = "Europe/Stockholm";

  # Use lanzaboote and secureboot
  boot.bootspec.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot = {

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.consoleMode = "max";
    loader.systemd-boot.configurationLimit = 5;
    loader.timeout = 0;
    ## qiet boot please
    plymouth.enable = true;
    plymouth.theme = "breeze";
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
  };
  ## TTY
  #services.kmscon =
  #  {
  #    enable = true;
  #    hwRender = true;
  #extraConfig =
  #  ''
  #    font-name=Lat2-Terminus16
  #    font-size=14
  #  '';
  #  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "sv-latin1";
    useXkbConfig = false; # use xkbOptions in tty.
  };

  # Configure keymap in X11
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";


  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = "auth include login";
  };
  # tailscale, of course
  services.tailscale.enable = true;
  # required for secret-tool and 1password integration in wofi
  services.gnome.gnome-keyring = {
    enable = true;
  };

  networking = {
    hostName = "ogge"; # Define your hostname.
    useDHCP = lib.mkForce true;
    #interfaces.enp2s0.useDHCP = true;
    #interfaces.wlp3s0.useDHCP = true;
    #  networking.wireless.networks.Tele2_9c594f.psk = "cd3m2y4a";  
    networkmanager.enable = true;
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      pavucontrol #sound control
      mako # notification daemon
      swaylock # lockscreen
      swayidle
      sworkstyle #workspace renaming utility
      breeze-icons
      breeze-gtk
      wl-clipboard
      wl-gammactl

      # xwayland # for legacy apps
      # waybar # configured as separate module
      kanshi # autorandr
      # dmenu
      # wofi # replacement for dmenu
      brightnessctl
      gammastep # make it red at night!
      # sway-contrib.grimshot # screenshots
      # swayr #Swayr, a window-switcher & more for sway


      mate.caja
      # gnome.nautilus # file explorer
      evince # document viewer (pdf etc.)

      # https://discourse.nixos.org/t/some-lose-ends-for-sway-on-nixos-which-we-should-fix/17728/2?u=senorsmile
      gnome3.adwaita-icon-theme # default gnome cursors
      glib # gsettings
      dracula-theme # gtk theme (dark)
      #gnome.networkmanagerapplet
    ];
  };



  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Enable sound.
  #sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.ogge = {
    isNormalUser = true;
    home = "/home/ogge";
    description = "Ogglord";
    extraGroups = [ "wheel" "audio" "realtime" "networkmanager" ]; # Enable ‘sudo’ for the user.    
  };



  # List services that you want to enable:
  programs.zsh.enable = true;
  programs.light.enable = true;

  # needed for gnupg
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;
  xdg = {
    portal = {
      enable = true;
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

  security.sudo.extraRules = [
    {
      users = [ "ogge" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/reboot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/tailscale";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  system.stateVersion = "23.05";
}

