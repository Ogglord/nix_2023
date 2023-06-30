{ pkgs, lib, nix-gaming, ... }:
let
  proton-ge-custom = nix-gaming.packages.${pkgs.system}.proton-ge;
  inherit (lib) mkOption mkIf mdDoc types literalExpression makeBinPath;
in
{
  environment.systemPackages = with pkgs; [ proton-ge-custom ];

  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server    
  };

  ## fix
  environment.variables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = makeBinPath [ proton-ge-custom ];
  };

  # debug = mkOption {
  #   type = types.string;
  #   default = "";
  #   description = builtins.trace proton-ge.out 0;
  # };

}
      
