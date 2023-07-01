{ pkgs, hostType, stylix, nix-gaming, sworkstyle, nix-vscode-extensions, ... }: {
  # nix-index-database, stylix,
  imports = [
    (
      if hostType == "nixos" then ./nixos.nix
      else if hostType == "darwin" then ./darwin.nix
      else throw "Unknown hostType '${hostType}' for core"
    )
    #./nix.nix
  ];

  #   documentation = {
  #     enable = true;
  #     doc.enable = true;
  #     man.enable = true;
  #     info.enable = true;
  #   };

  environment = {
    pathsToLink = [
      "/share/zsh"
    ];
    systemPackages = with pkgs; [
      #man-pages
      #neovim
      #rsync
      tree
      ncdu
      neofetch
      fortune
      jq
      micro
      nil # NI Language interpreter
      nixpkgs-fmt
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit hostType stylix nix-gaming sworkstyle nix-vscode-extensions; # impermanence nix-index-database stylix
    };
  };

  programs = {
    #nix-index.enable = true;
    #fish.enable = true;
    zsh.enable = true;
  };

  #   stylix = {
  #     base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  #     # We need this otherwise the autoimport clashes with our manual import.
  #     homeManagerIntegration.autoImport = false;
  #     # XXX: We fetchurl from the repo because flakes don't support git-lfs assets
  #     image = pkgs.fetchurl {
  #       url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
  #       hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
  #     };
  #   };
}
