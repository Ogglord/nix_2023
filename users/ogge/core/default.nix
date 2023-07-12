{ hostType, pkgs, stylix, ... }: {
  # impermanence, nix-index-database, stylix,
  imports = [

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

  dconf.enable = false;


  home = {
    username = "ogge";
    stateVersion = "23.05";
    packages = with pkgs; [
      #bandwhich
      #colorcheck 
      rofi-themes2
      nix-index
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
