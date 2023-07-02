{ agenix, config, lib, pkgs, home-manager, impermanence, lanzaboote, nix-index-database, stylix, nix-ld, bootType, nix-gaming, nix-vscode-extensions, ... }:
{
  imports = [
    agenix.nixosModules.age
    home-manager.nixosModules.home-manager
    #impermanence.nixosModules.impermanence
    #catppuccin.nixosModules.catppuccin
    stylix.nixosModules.stylix
    nix-ld.nixosModules.nix-ld
    nix-index-database.nixosModules.nix-index
    #stylix.nixosModules.stylix
    #./resolved.nix
    #./tmux.nix
    #./xdg.nix
  ] ++ lib.optionals (bootType == "secureboot") [ lanzaboote.nixosModules.lanzaboote ];

  # stylix.image = pkgs.fetchurl {
  #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
  #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  # };
  stylix.image = ./wallpaper2.jpg;

  boot.kernelParams = [ "log_buf_len=10M" ];

  #   documentation = {
  #     dev.enable = true;
  #     man.generateCaches = true;
  #   };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    useDHCP = false;
    useNetworkd = false;
    wireguard.enable = true;
    nameservers = [ "100.100.100.100" "1.1.1.1" ];
    search = [ "turkey-kelvin.ts.net" ];
  };

  programs = {
    command-not-found.enable = false;
    #mosh.enable = true;
    zsh.enableGlobalCompInit = false;
  };

  security = {
    #pam.services.sudo.u2fAuth = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };

  services = {
    dbus.implementation = "broker";
    openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkDefault "no";
    };
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
    #fwupd.daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };

  system = {
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';

    stateVersion = "23.05";
  };

  systemd = {
    enableUnifiedCgroupHierarchy = true;
    network.wait-online.anyInterface = true;
    services.tailscaled.after = [ "network-online.target" "systemd-resolved.service" ];
  };

  users.mutableUsers = true; ## warning set to false will wipe users and passwords unlet set explicitly!
}
