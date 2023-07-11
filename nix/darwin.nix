{ self
, darwin
, home-manager
, nix-index-database
, nixpkgs
, stylix
, ...
}:
let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { hostPlatform, type, ... }:
    darwin.lib.darwinSystem {
      system = hostPlatform;
      pkgs = self.pkgs.${hostPlatform};
      modules = [
         ./trace.nix
        (../hosts + "/${hostname}")
        {
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            p.flake = nixpkgs;
            #templates.flake = templates;
          };
        }
      ];
      specialArgs = {
        hostType = type;
        inherit home-manager nix-index-database stylix; # 
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.darwin or { })
