{ config, pkgs, lib, ... }:
let
  message = "Enabling networkd for batu static IPv4 ...";
in
{
  networking = {
    usePredictableInterfaceNames = false;
    hostName = "batu";
  };
  ## I want this to show
  systemd.network.enable = builtins.trace message true;

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
}

