{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      #bbenoist.nix
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
      bungcip.better-toml
      tyriar.sort-lines
      ms-vscode-remote
    ];

    userSettings = {
      "window.zoomLevel" = 1;
      "workbench.colorTheme" = "Dracula";
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
      "editor.formatOnSave" = true;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "window.titleBarStyle" = "custom";
      "workbench.tree.indent" = 22;
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
