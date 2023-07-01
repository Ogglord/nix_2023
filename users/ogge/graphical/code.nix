{ pkgs, lib, nix-vscode-extensions, ... }:
let
  extensions = nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
in
{

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    #package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      #bbenoist.nix
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
      bungcip.better-toml
      tyriar.sort-lines
      ms-vscode-remote.remote-ssh
      piousdeer.adwaita-theme
      extensions.equinusocio.vsc-material-theme-icons
      vscode-icons-team.vscode-icons
    ];

    userSettings = {
      "editor.formatOnSave" = true;
      "window.zoomLevel" = 1;
      #"workbench.colorTheme" = "Dracula";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "diagnostics" = {
            "ignored" = [ "unused_binding" "unused_with" ];
          };
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
      "editor.fontSize" = 12;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "window.titleBarStyle" = "custom";
      "workbench.tree.indent" = 22;

      "workbench.iconTheme" = "vscode-icons";
      #"workbench.iconTheme" = "eq-material-theme-icons-ocean"; ## darker folders
      "terminal.integrated.copyOnSelection" = true;
    };


    globalSnippets = {
      nix = {
        body = [
          ''
            { ... }:
            {
              $0
            }
          ''
        ];
        description = "Empty nix body for import (non-flake)";
        prefix = [
          "Empty nix"
        ];
      };
    };


  };

}

