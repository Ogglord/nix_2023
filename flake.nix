{
  description = "Ogglords Flake based NixOS configuration Juny 2023";

  nixConfig = {
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-config.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secure boot package
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    #rofi-themes2-src.url = "github:newmanls/rofi-themes-collection/master";
    #rofi-themes2-src.flake = false;

    #flake-compat = {
    #  url = "github:edolstra/flake-compat";
    #  flake = false;
    #};
    #catppuccin.url = "github:Stonks3141/ctp-nix";
    #catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    #catppuccin.inputs.flake-compat.follows = "flake-compat";
    # XXX: https://github.com/NixOS/nix/pull/8047
    #nix = {
    #  url = "github:lovesegfault/nix/always-allow-substitutes-backport";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.flake-compat.follows = "flake-compat";
    #};

    ## dynamic linker (requires impure, for vscode remote host)
    #nix-ld.url = "github:Mic92/nix-ld";
    #nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ]; # 
    in
    {
      hosts = import ./nix/hosts.nix;

      pkgs = forAllSystems (localSystem: import nixpkgs {
        inherit localSystem;
        overlays = [ self.overlays.default ];
        config.allowUnfree = true;
        config.allowAliases = true;
      });

      #checks = forAllSystems (import ./nix/checks.nix inputs);
      #devShells = forAllSystems (import ./nix/dev-shell.nix inputs);
      overlays = import ./nix/overlay.nix inputs;
      packages = forAllSystems (import ./nix/packages.nix inputs);

      #deploy = import ./nix/deploy.nix inputs;
      darwinConfigurations = import ./nix/darwin.nix inputs;
      homeConfigurations = import ./nix/home-manager.nix inputs;
      nixosConfigurations = import ./nix/nixos.nix inputs;
    };
}
