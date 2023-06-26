{ pkgs, lib, unstable, inputs, ... }:
let
  system = "x86_64-linux";
  nil = inputs.nil.packages.${system}.default;
  devenv = inputs.devenv.packages.x86_64-linux.devenv;
  my-python-packages = ps: with ps; [
    #pandas
    #requests
    #"os_sys"
    #pycairo
    #pygobject3
  ];
in
{

  environment.systemPackages = with pkgs;
    [
      ## fonts
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })

      _1password

      (pkgs.python3.withPackages my-python-packages)

      alacritty # terminal written in rust                
      authy
      bash
      bat
      brave
      croc # send receive files from CLI across internet
      devenv # load up a dev env using nix flakes in one line
      emptty # Dead simple CLI Display Manager on TTY.
      exa # better ls
      fortune # fortune cookie
      gopass ## password manager backend
      greetd.tuigreet #graphical console greeter for greetd.
      gtk3
      jq # json formatter
      libdrm # for getting ADM GPU Name
      libnotify
      libsecret
      libvirt
      micro # better nano
      neofetch
      nil # NI Language interpreter
      nixpkgs-fmt
      pkg-config
      polkit
      polkit_gnome
      psst ## spotify client
      roboto # serif default
      sysz # a systemctl gui 
      tree # file tree vis
      tailscale
      ubuntu_font_family # sans-serif default
      vulkan-tools
      wget
      # gui apps
      # alacritty # terminal
      # blender # 3D modelling
      # calibre # manage ebooks
      # chromium # used for vhs
      # discord # chat app
      # firefox # alternative browser if qutebrowser doesn't work
      # flameshot # screenshots
      # gimp # image editing
      # imagemagick # convert between image data type
      # inkscape # drawing tool
      # libresprite # pixel art tool
      # musescore # musescore
      # peek # gif capturing tool
      # qutebrowser # broswer with vim controls
      # rustdesk # remote connection to other computers
      # spotify # music
      # tdesktop # telegram desktop app
      # teamspeak_client # voice chat
      # thunderbird # email client
      # zulip # zulip client
      # # unstable
      # unstable.godot_4 # game engine
      # unstable.zathura # pdf reader

      # # cli utils
      # # gitoxide  # rusty git
      # bat # better cat
      # binutils
      # blueberry # bluetooth config
      # btop # better top
      # butler # itch.io deploy
      # cocogitto # git tooling for conventional commits and other stuff
      # colorpicker # colorpicker
      # delta # diffs
      # difftastic
      # du-dust # better du
      # duf # shows free space on drives
      # dunst # notifications
      # exercism # exercism cli tool for downloading/submitting
      # fd # better find
      # fzf # fuzzy finder
      # gh # github cli tool
      # git # git
      # git-cliff
      # git-lfs # git large file storage
      # glab # gitlab cli tool
      # gum # cli scripting glue
      # hoard # cli command saver
      # hurl # test http requests
      # jq # json cli processing
      # just # make alternative
      # license-generator # generate standard licenses
      # lsof
      # mdbook # pdf books from markdown
      # mpv # cli media player
      # nix-index
      # openssl # ssh
      # pciutils
      # ranger # cli file manager
      # restream # stream remarkable to pc screen
      # ripgrep # better grep
      # sd # better sed
      # taskwarrior # todo app
      # tealdeer # shorter man with examples
      # tokei # better loc

      # unzip # zip
      # vhs # terminal camera
      # xdotool # automatically type text
      # zip # zip
      # zola # website generation
      # zoxide # faster jumping around dirs
      # zsh # better bash

      # xclip # clipboard on x11
      # haskellPackages.greenclip # clipboard manager, daemon needs to be started

      # # for tmux battery
      # acpi
      # upower

      # # ui
      # brightnessctl
      # i3lock-fancy

      # # stuff
      # clang
      # lld
      # lldb
      # killall
      # pkg-config
      # wget
      # wpa_supplicant
      # usbutils

      # # graph utilities
      # graphviz # standard on linux
      # xdot # interactive viewer for graphviz

      # # audio
      # pamixer

      # # rust
      # rustup
      # mold

      # # rust cargo extensions
      # cargo-audit
      # cargo-bloat
      # cargo-deny
      # cargo-edit
      # cargo-expand
      # cargo-fuzz
      # cargo-generate
      # cargo-hack
      # cargo-license
      # cargo-llvm-lines
      # cargo-make
      # cargo-modules
      # cargo-nextest
      # cargo-outdated
      # cargo-udeps
      # cargo-update
      # cargo-watch
      # cargo-leptos
      # hyperfine

      # # haskell
      # cabal-install
      # cabal2nix
      # haskellPackages.implicit-hie
      # # hoogle generate doesn't work (timeout)
      # unstable.haskellPackages.hoogle
      # haskellPackages.fast-tags
      # haskellPackages.haskell-debug-adapter
      # haskellPackages.ghci-dap
      # ghc
      # haskell-language-server
      # ormolu

      # # local markdown slides
      # jekyll

      # # lua
      # luajit
      # lua-language-server

      # # gpg
      # pinentry # passphrase input
      # gnupg # key signing
      # gpgme # key signing
      # pass
      # rofi-pass

      # # wasm
      # #unstable.wasm-bindgen-cli # not always up to date
      # wasm-pack

      # # javascript 
      # nodejs

      # # docker
      # docker-compose


    ];
}
