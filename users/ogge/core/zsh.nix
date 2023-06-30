{ pkgs, lib, ... }:
{
  
  programs.zsh = {
    enable = true;


    initExtraFirst =
      ''        
        # nix-switch <command> <optionalAction[switch is default]>
        function nix-switch {
            pushd /home/ogge/nix > /dev/null

            git add .

            readonly command=''${1:?"The command to nix-switch must be specified."}
            shift
            action="''${@:-switch}"

            case $command in

              system)
                echo "executing: sudo nixos-rebuild $action --flake '.#'"
                sudo nixos-rebuild $action --flake '.#'
                ;;

              home)
                echo "executing: home-manager $action --flake '.#ogge@ogge'"
                home-manager $action --flake '.#ogge@ogge'
                ;;
            
              *)
                echo "invalid command: \"$command\". Supported: system, home."
                ;;
            esac

            popd > /dev/null
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
      eval $(ssh-agent) > /home/ogge/.sshstartup.log && ssh-add /home/ogge/.ssh/ida_rsa 2>> /home/ogge/.sshstartup.log

      export NIX_BUILD_SHELL="zsh"
      fpath+=(~/.zfunc)
    '';

    shellAliases = {
      hm = "nix-switch home";
      sys = "nix-switch system";
      reload = ''(source ~/.zshrc ; echo "Reloading zsh config"...)'';
      exa = "exa --group-directories-first --color-scale -g";
      ls = "exa";
      ll = "exa -alh";
      l = "exa -lh";
      lt = "exa -laTh";
      la = "exa -al";
      rofi = "rofi -i";
      #help = ''( echo "Hi Ogglord, in case your forgot:"; echo "nixos-rebuild (flake mode): 'nr switch' or 'nr build'"; echo "home-manager (flake mode): 'hm switch' or 'hm build'" )'';
      cat = "bat";
      g = "git";
      ga = "git add";
      gaa = "git add --all";

      gbs = "git bisect";
      gbss = "git bisect start";
      gbsb = "git bisect bad";
      gbsg = "git bisect good";
      gbsr = "git bisect run";
      gbsre = "git bisect reset";

      gc = "git commit -v";
      "gc!" = "git commit -v --amend";
      "gcan!" = "git commit -v -a --no-edit --amend";
      gcb = "git checkout -b";

      gcm = "git checkout master";
      gcmsg = "git commit -m";
      gcp = "git cherry-pick";

      gd = "git diff";
      gdc = "git diff --cached";
      gdw = "git diff --word-diff";
      gdcw = "git diff --cached --word-diff";

      gf = "git fetch";
      gl = "git pull";
      glg = "git log --stat";
      glgp = "git log --stat -p";
      gp = "git push";
      gpsup = "git push -u origin $(git symbolic-ref --short HEAD)";
      gr = "git remote -v";
      grb = "git rebase";
      grbi = "git rebase -i";
      grhh = "git reset --hard HEAD";
      gst = "git status";
      gsts = "git stash show --text --include-untracked";
      gsta = "git stash save";
      gstaa = "git stash apply";
      gstl = "git stash list";
      gstp = "git stash pop";
      glum = "git pull upstream master";
      gwch = "git log --patch --no-merges";
    };

  };
}
