{
  description =
    "NixOS configuration and home-manager configurations for ogge";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/nur";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; 	
    };
  };
  
  outputs = { self, nixpkgs, lanzaboote, nur, utils, home-manager, nil, ... }@attrs: 
  {
	nixosConfigurations.nixos = 
	  let
    	system = "x86_64-linux";
	  	allowUnfree = { nixpkgs.config.allowUnfree = true; };

        specialArgs = {
                   inherit nixpkgs nil;
        };

	    modules = [
	      ./configuration.nix
	      allowUnfree
	      nur.nixosModules.nur
	      lanzaboote.nixosModules.lanzaboote
		  home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ogge = import /home/ogge/.config/home-manager/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }	
	    ];
	 in
	   nixpkgs.lib.nixosSystem {
      	 inherit system modules specialArgs;
       };
	  
  };
}
