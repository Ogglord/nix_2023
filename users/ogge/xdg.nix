{ pkgs, ... }:
{
  home.packages = [ pkgs.xdg-user-dirs pkgs.mimeo ];
  xdg =
    let
      homePath = /home/ogge;
    in
    {
      enable = true;
      userDirs = {

        enable = true; ## own $XDG_CONFIG_HOME/user-dirs.dirs
        createDirectories = true;
        download = builtins.toString (homePath + "/Downloads");
        pictures = builtins.toString (homePath + "/Pictures");

        desktop = builtins.toString homePath;
        documents = builtins.toString homePath;
        music = builtins.toString homePath;
        publicShare = builtins.toString homePath;
        templates = builtins.toString homePath;
        videos = builtins.toString homePath;
      };
      cacheHome = homePath + "/.cache";
      configHome = homePath + "/.config";
      dataHome = homePath + "/.local/share";
      stateHome = homePath + "/.local/state";

      mime.enable = true;
      mimeApps.enable = true; # handles manually in 

      ## Desktop Entries allow applications to be shown in your desktop environment's app launcher.
      desktopEntries = {
        screenshot = {
          name = "Screenshot";
          genericName = "screenshot";
          exec = "/home/ogge/.local/bin/screenshot";
          terminal = false;
          categories = [ "Utility" ];
          mimeType = [ "text/x-shellscript" ];
        };
        nixos-rebuild = {
          name = "Rebuild (NixOs)";
          genericName = "update";
          exec = "sys";
          terminal = true;
          categories = [ "Utility" ];
          mimeType = [ "text/x-shellscript" ];
        };
      };

      ## sane defaults
      mimeApps.defaultApplications = {
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";

      };




    };
}





