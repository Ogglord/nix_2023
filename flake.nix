{
  description = "Ogglords Flake based NixOS configuration Juny 2023";

  inputs = {
    # secure boot package
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    #user repositories (not used any yet)
    nur.url = "github:nix-community/nur";
    # NIx Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "unstable";
    };
    # dev environments on the fly
    devenv.url = "github:cachix/devenv/latest";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    # for proton-ge
    nix-gaming.url = "github:fufexan/nix-gaming";
    # Local directories (for absolute paths you can omit 'path:')
    # sway workplace renaming toolip 
    sworkstyle.url = "github:ogglord/sworkstyle";

    rofi-themes2-src.url = "github:newmanls/rofi-themes-collection/master";
    rofi-themes2-src.flake = false;


    nix-ld.url = "github:Mic92/nix-ld";
    # this line assume that you also have nixpkgs as an input
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    #yanky-src = {
    #  url = "github:gbprod/yanky.nvim";
    #  flake = false;
    #};
    #hlargs-src = {
    #  url = "github:m-demare/hlargs.nvim";
    #  flake = false;
    #};
  };
  outputs = { self, lanzaboote, nixpkgs, unstable, home-manager, nur, nil, sworkstyle, nix-ld, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };


      rofi-themes2 = pkgs.stdenv.mkDerivation {
        name = "rofi-themes2";
        src = builtins.filterSource
          (path: type: type != "directory" || baseNameOf path != ".rofi")
          inputs.rofi-themes2-src;

        nativeBuildInputs = [ ];
        # pathExists path

        installPhase = ''
          runHook preInstall
          ls -al $src
          mkdir -p $out
          cp -r $src/themes/. $out/
          runHook postInstall
        '';
      };

      defaults = { pkgs, ... }: {
        _module.args =
          let
            make-available-in-args = p: import p { inherit (pkgs.stdenv.targetPlatform) system; };
          in
          {
            unstable = make-available-in-args inputs.unstable;
            nur = make-available-in-args inputs.nur;
            rofi-themes2 = rofi-themes2;
            system = system;
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
                ./system/configuration.nix
              ];
          };
          batu = nixpkgs.lib.nixosSystem {
            inherit system;
            #specialArgs = {inherit inputs;};
            modules =
              [
                nix-ld.nixosModules.nix-ld
                defaults
                ./seedbox/configuration.nix
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
          "ogge@batu" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance   

            modules = [
              defaults
              ./seedbox/home-manager.nix
            ];

          };
        };
    };
}
