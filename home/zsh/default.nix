{ pkgs, lib, ... }:
{
  imports = [
    # shell prompt
    ./starship
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      la = "exa -al";
      l = "exa -l";
      ll = "exa -alh";
      ls = "exa";

      help = ''( echo "Hi Ogglord, in case your forgot:"; echo "nixos-rebuild (flake mode): 'nr switch' or 'nr build'"; echo "home-manager (flake mode): 'hm switch' or 'hm build'" )'';
      #nix-swi = "sudo nixos-rebuild switch --flake '~/nix/.#ogge'";
      #home-swi = "home-manager switch --flake '~/nix/.#ogge'";
    };

    initExtraFirst =
      ''
        # hm <command> <optionalExtraArg>
        function hm {
            pushd /home/ogge/nix

            git add .

            readonly command=''${1:?"The command to home-manager must be specified."}
          
            home-manager "$command" --flake '.#ogge@ogge' $2

            popd
        } 
        # nr <command> <optionalExtraArg>
        function nr {
            pushd /home/ogge/nix

            git add .

            readonly command=''${1:?"The command to nixos-rebuild must be specified."}
          
            sudo nixos-rebuild "$command" --flake '.#' $2

            popd
        } 
      '';

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    autocd = true;
    #oh-my-zsh = {
    #  enable = true;	
    #  plugins = [ "git" "sudo"];
    #  theme = "robbyrussell";
    #};

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      save = 100000;
      size = 100000;
      path = "/home/ogge/.zhistory";
    };

    historySubstringSearch = {
      enable = true;
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "nix-community/nix-zsh-completions"; }
        { name = "chisui/zsh-nix-shell"; }
      ];
    };

    initExtra = ''
      #eval "$(zoxide init zsh)"
      #eval $(ssh-agent) > /home/ogge/.sshstartup.log && ssh-add /home/ogge/.ssh/ida_rsa 2>> /home/ogge/.sshstartup.log

      export NIX_BUILD_SHELL="zsh"      

      fpath+=(~/.zfunc)
    '';

  };
}
