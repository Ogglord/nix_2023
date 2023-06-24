{
  description = "Ogglords Flake based NixOS configuration Juny 2023";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    # secure boot package
    lanzaboote.url = "github:nix-community/lanzaboote";
    # NIx Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    # Local directories (for absolute paths you can omit 'path:')
    # sway workplace renaming toolip 
    sworkstyle.url = "path:flakes/sworkstyle";

    #yanky-src = {
    #  url = "github:gbprod/yanky.nvim";
    #  flake = false;
    #};
    #hlargs-src = {
    #  url = "github:m-demare/hlargs.nvim";
    #  flake = false;
    #};
  };
  outputs = { self, lanzaboote, nixpkgs, unstable, home-manager, nur, nil, sworkstyle, ... }@inputs:
    let
      system = "x86_64-linux";

      defaults = { pkgs, ... }: {
        _module.args =
          let
            make-available-in-args = p: import p { inherit (pkgs.stdenv.targetPlatform) system; };
          in
          {
            unstable = make-available-in-args inputs.unstable;
            nur = make-available-in-args inputs.nur;
            inputs = inputs; # removes the need for specialArgs = {inherit inputs;};
          };
      };
    in
    {
      nixosConfigurations =
        {
          ogge = nixpkgs.lib.nixosSystem {
            inherit system;
            #specialArgs = {inherit inputs;};
            modules =
              [
                lanzaboote.nixosModules.lanzaboote
                defaults
                ./configuration.nix
              ];
          };
        };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations =
        let
          nixosConfig = self.nixosConfigurations;
        in
        {
          "ogge@ogge" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance        
            modules = [
              defaults
              ./home/home-manager.nix
            ];
          };
        };
    };
}
