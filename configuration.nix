{ config, pkgs, lib, inputs, unstable, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports =
    [
      ./env
      ./hardware/desktop.nix
      #./home
      #      ./windowmanager
      ./system-packages
      ./system-packages/greetd
      #      ./neovim
    ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Stockholm";

  # Use the lanzaboote and secureboot
  boot.bootspec.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
    useXkbConfig = false; # use xkbOptions in tty.
  };

  # Configure keymap in X11
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

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

  # Fonts
  fonts = {
    #enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
      roboto
      ubuntu_font_family
      noto-fonts-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Roboto Slab" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Hack Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
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

