{ config, pkgs, lib, ...}:
let
  msg = "enabling networkd...";
in 
{
    networking = {
        usePredictableInterfaceNames = false;
        hostName = "batu";
    };

    systemd.network.enable = builtins.trace msg true;

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

#networking = {
 #  usePredictableInterfaceNames = false;
 #  hostName = "batu";
  #  ## configure network
  #  firewall.enable = false;
  #  interfaces.eth0 =
  #    {
  #      name = "eth0";
  #      ipv4.addresses = [{
  #        address = "194.87.149.71";
  #        prefixLength = 26;
  #      }];
        # ipv4.routes = [
        #   {
        #     address = "default";
        #     prefixLength = 0;
        #     via = "194.87.149.65";
        #   }
        # ];
  #    };
   #   defaultGateway =
   #   {
   #     address = "194.87.149.65";
   #     interface = "eth0";
#
   #   };
  #  nameservers = lib.mkForce [ "1.1.1.1" "8.8.8.8" ];
  #  useNetworkd = lib.mkForce false;
  #  localCommands = "ip route flush 0/0; ip route add 194.87.149.65 dev eth0; ip route add default via 194.87.149.65 dev eth0";
    ## sudo ip route add default via 194.87.149.65 dev eth0
  #};