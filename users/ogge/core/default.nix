{ hostType, pkgs, stylix, ... }: {
  # impermanence, nix-index-database, stylix,
  imports = [
    #catppuccin.homeManagerModules.catppuccin
    #impermanence.nixosModules.home-manager.impermanence
    #nix-index-database.hmModules.nix-index
    #stylix.homeManagerModules.stylix
    # {
    #   stylix.image = ./wallpaper.jpg;
    # }

    # ./bash.nix
    # ./btop.nix
    # ./fish.nix
    ./git.nix
    # ./htop.nix
    # ./neovim
    # ./ssh.nix
    ./micro.nix
    ./starship.nix
    # ./tmux.nix
    # ./xdg.nix
    ./zsh.nix
  ];
  #catppuccin.flavour = "latte";
  # XXX: Manually enabled in the graphic module
  dconf.enable = false;


  home = {
    username = "ogge";
    stateVersion = "23.05";
    packages = with pkgs; [
      #bandwhich
      #colorcheck 
      rofi-themes2
      exa
      #fd
      #kalker
      #mosh
      base16-schemes
      neofetch
      rclone
      ripgrep
      #rsync
    ];
  };

  programs = {
    #atuin = { # Atuin replaces your existing shell history with a
    # # SQLite database, and records additional context for your commands.
    #  enable = true;
    #  settings.auto_sync = false;
    #  flags = [ "--disable-up-arrow" ];
    #};
    bat.enable = true;
    #fzf.enable = true;
    gpg.enable = true;
    #nix-index.enable = true;
    #zoxide.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
