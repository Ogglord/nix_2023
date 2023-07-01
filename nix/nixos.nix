{ self
, home-manager
, agenix
, lanzaboote
, nix-index-database
, nixos-hardware
, nixpkgs
, nix-ld
, stylix
, nix-gaming
, sworkstyle
, ...
}:
let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, type, bootType, ... }:
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
        bootType = bootType;
        inherit agenix home-manager lanzaboote nix-index-database nixos-hardware nix-ld stylix nix-gaming sworkstyle; /* nix-ld catppuccin nix-index-database stylix impermanence*/
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.nixos or { })
