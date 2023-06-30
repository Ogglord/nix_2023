{ lib, pkgs, ... }: {
  imports = [ ../../users/ogge ];

  home = {
    uid = 123123;
    packages = with pkgs; [ ];
  };

  programs = {
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
      '';
      profileExtra = ''
        if [ -f /etc/bashrc ]; then
        . /etc/bashrc
        fi
        export PATH="$PATH:$HOME/.local/bin"
      '';
    };

    git.userEmail = lib.mkForce "oag@proton.me";
    zsh = {
      initExtraBeforeCompInit = ''
        fpath+=("$HOME/.zsh/completion")
      '';
      initExtra = ''
        export PATH="$PATH:$HOME/.local/bin"
      '';
    };
  };
}
