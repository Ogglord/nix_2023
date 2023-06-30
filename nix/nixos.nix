{ self
, home-manager
, agenix
, lanzaboote
, nixos-hardware
, nixpkgs
, nix-ld
, ...
}:
let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, type, ... }:
    lib.nixosSystem {
      modules = [
        (../hosts + "/${hostname}")
        {
          nixpkgs.pkgs = self.pkgs.${hostPlatform};
        }
      ];
      specialArgs = {
        hostAddress = address;
        hostType = type;
        inherit agenix home-manager lanzaboote nixos-hardware nix-ld; /*nix-index-database stylix impermanence*/
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.nixos or { })