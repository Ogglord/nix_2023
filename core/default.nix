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
      rsync
      git
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


}
