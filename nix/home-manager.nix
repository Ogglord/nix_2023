{ self
, home-manager
  #, nix-index-database
, nixpkgs
  #, impermanence
  #, stylix
  #, templates
, ...
}:
let
  inherit (nixpkgs) lib;

  genModules = hostName: { homeDirectory, ... }:
    { config, pkgs, ... }: {
      imports = [ (../hosts + "/${hostName}") ];

      home = {
        inherit homeDirectory;
        sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
          "nixpkgs=${config.xdg.dataHome}/nixpkgs"
        ];
      };
      xdg = {
        dataFile.nixpkgs.source = nixpkgs;
        configFile."nix/nix.conf".text = ''
          flake-registry = ${config.xdg.configHome}/nix/registry.json
        '';
      };
    };

  genConfiguration = hostName: { hostPlatform, type, ... }@attrs:
    home-manager.lib.homeManagerConfiguration {
      pkgs = self.pkgs.${hostPlatform};
      modules = [ (genModules hostName attrs) ];
      extraSpecialArgs = {
        hostType = type;
        #inherit impermanence nix-index-database stylix;
      };
    };
in
#lib.mapAttrs genConfiguration (self.hosts.homeManager or { })
lib.mapAttrs genConfiguration (self.hosts.homeManager)
