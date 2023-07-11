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
, nix-vscode-extensions
, ...
}:
let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, type, bootType, pubkey, extraRoles, ... }:
    lib.nixosSystem {
      modules = [
        ./trace.nix
        (../hosts + "/${hostname}")
        {
          nixpkgs.pkgs = self.pkgs.${hostPlatform};
        }
      ];
      specialArgs = {
        ## inherit host attributes
        hostName = "${hostname}";
        hostAddress = address;
        hostType = type;
        bootType = bootType;
        pubkey = pubkey;
        extraRoles = extraRoles;
        inherit agenix home-manager lanzaboote nix-index-database nixos-hardware nix-ld stylix nix-gaming sworkstyle nix-vscode-extensions; /* nix-ld catppuccin nix-index-database stylix impermanence*/
      };
    };
in
lib.mapAttrs genConfiguration (self.hosts.nixos or { })
