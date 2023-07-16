{ config, pkgs, lib, ... }:
let
  description = "Enabling systemd.network for batu (static IPv4) ...";
in
{
  ## enable IP forwarding (for tailscale exit node)
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  ## legacy networking device names
  networking = {
    usePredictableInterfaceNames = false;
    hostName = "batu";
  };

  ## enable networkd, and trace it to stdout
  systemd.network.enable = builtins.trace description true;

  systemd.network.networks."10-wan" = {
    # match the interface by name
    #matchConfig.Name = "eth0";
    # match the interface by type
    matchConfig.Type = "ether";
    address = [
      # configure addresses including subnet mask /26 =  255.255.255.192
      "194.87.149.71/26"
    ];
    routes = [
      # create default routes for  IPv4, which is on our subnet
      { routeConfig.Gateway = "194.87.149.65"; }
      # or when the gateway is not on the same network
      #{ routeConfig = {
      #Gateway = "194.87.149.65";
      #GatewayOnLink = true;
      #}; }
    ];
    # make the routes on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
    linkConfig.ActivationPolicy = "always-up";
  };
  ## this works, but requires at least one initial manual login.. this can be avoided by using a pre-defined key (non-expiring)
  system.activationScripts.script.text = ''echo "Enabling tailscale exit node (${pkgs.tailscale}/bin/tailscale)...";${pkgs.tailscale}/bin/tailscale up --ssh --advertise-exit-node'';
}

