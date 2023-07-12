{ config, lib, nixos-hardware, pkgs, bootType, extraRoles, ... }:
{
  imports = [
    ./networking.nix
    ../../core
    ../../hardware/batu.nix
    ../../users/ogge
  ];

  boot.loader.grub = lib.mkIf (bootType == "legacy") {
    enable = true;
    device = "/dev/sda";
    efiSupport = false;
  };

  system.nixos.label = "anywhere";
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
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
  ];

  ## enable autobrr
  services.autobrr.enable = true;
  services.autobrr.package = pkgs.autobrr;
  services.autobrr.configFilePath = "/home/ogge/.config/autobrr/";
  services.autobrr.systemd.enable = true;

  ## enable SSH Daemon
  services.sshd.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.defaultUserShell = pkgs.zsh;
  users.users.ogge = {
    isNormalUser = true;
    home = "/home/ogge";
    description = "Ogglord";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.    
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWX4zp7ZFi3au4GfaMi2pOgtX9gUUw8gsykQKDt8KtG8Y9TQnmTKqXSr/WlxO9FScBVSd91269lKqGf4jyLopN+nRjr7vfQcDtm70NNeH3Z48feMOpfBOv4g2ntn4q/lJxktHe2cGSX5V0SHNTEd+LKC+cHjokITxkiS6VyWyrB40JrQW2U5aOrABVto5gDunsSbyPvNyNwQCOL+5cAaOjDn+1G6kg9+TXZrqh8KeB0lJddDWvWjlW/CxRymvgMTBvL/EjghlNMfr91hTGiUpeFIJOAqNsfgnHu/SMLUB9D0LiZ20YTvG61tb+4tyzm96nAftz6iNT3Nj+N/FEnywqbpFGZ5D8FY623Y0g1g7+VxoxhkErcbnQB9jR2aTFZm00y3WgpxquISfzJFmyOSGAPjCLn4KMPfclwuZfH/7T2gLHkrmr046QqPpBSpWc6AvBQllML7e9L5UavFCFvySp3kRPZj5cp3jyjAxZq9vHpex3FxM0tTxAK+ReMjm2fec= ogge@ogge" ];
  };



  # List services that you want to enable:
  programs.zsh.enable = true;
  ## required for vs code remote
  programs.nix-ld.dev.enable = true;
  #programs.nix-ld.enable = true;


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

