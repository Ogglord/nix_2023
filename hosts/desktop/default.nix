{ config, lib, nixos-hardware, pkgs, bootType, pubkey, ... }:
#{ config, pkgs, lib, inputs, unstable, system, ... }:
{
  imports = [
    ../../core
    #../../seedbox/env.nix
    ../../hardware/desktop.nix
    ../../hardware/secureboot.nix
    # ../../hardware/nixos-aarch64-builder
    # ../../hardware/bluetooth.nix
    ../../hardware/sound.nix

    ../../graphical

    ../../users/ogge

    # ./sway.nix
    # ./hyperpixel4.nix
  ];

  networking = {
    hostName = "desktop"; # Define your hostname.
    useDHCP = lib.mkForce true;
    #interfaces.enp2s0.useDHCP = true;
    #interfaces.wlp3s0.useDHCP = true;
    #  networking.wireless.networks.Tele2_9c594f.psk = "cd3m2y4a";  
    networkmanager.enable = true;
  };

  system.nixos.label = "hardcore";
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

  environment.systemPackages = [
    pkgs.git
    pkgs.bash
    pkgs.libdrm ## for amd gpu name
  ];



  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.defaultUserShell = pkgs.zsh;
  users.users.ogge = {
    isNormalUser = true;
    home = "/home/ogge";
    description = "Ogglord";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.    
    openssh.authorizedKeys.keys = [ pubkey ]; # Add key defined for host
  };

  # List services that you want to enable:
  programs.zsh.enable = true;

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
}

