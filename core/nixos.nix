{ agenix, config, lib, pkgs, home-manager, impermanence, lanzaboote, nix-index-database, stylix, nix-ld, bootType, nix-gaming, nix-vscode-extensions, ... }:
{
  imports = [
    agenix.nixosModules.age
    home-manager.nixosModules.home-manager
    stylix.nixosModules.stylix
    nix-ld.nixosModules.nix-ld
    nix-index-database.nixosModules.nix-index
  ] ++ lib.optionals (bootType == "secureboot") [ lanzaboote.nixosModules.lanzaboote ];

  stylix.image = ./wallpaper2.jpg;

  boot.kernelParams = [ "log_buf_len=10M" ];

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };



  networking = {
    ## enable firewall, and trace it to stdout
    usePredictableInterfaceNames = false;
    nftables.enable = true;

    ## tailscale
    wireguard.enable = true;
    search = [ "turkey-kelvin.ts.net" ];
    nameservers = lib.mkDefault [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    firewall = {
      enable = builtins.trace "Enabling firewall (nftables)..." true;
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
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
