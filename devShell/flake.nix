{
  description = "A Nix-flake-based Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:/DavHau/mach-nix";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , mach-nix
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (self: super: {
          machNix = mach-nix.defaultPackage.${system};
          python = super.python311;
        })
      ];

      pkgs = import nixpkgs { inherit overlays system; };

    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ python machNix virtualenv gtk3 gobject-introspection glib ] ++
          (with pkgs.python311Packages; [
            pip
            pycairo
            pygobject3

          ]);

        shellHook = ''
          ${pkgs.python}/bin/python --version
        '';
      };
      devShells.ruby = pkgs.mkShell {
        packages = with pkgs; [
          ruby
          git
          #         pkg-config
          bundix
          #          gnumake
        ];

        shellHook = ''
          ${pkgs.ruby}/bin/ruby --version
        '';
      };
    });
}
