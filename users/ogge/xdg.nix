{ ... }:
{
  xdg =
    let
      homePath = /home/ogge;
    in
    {
      enable = true;
      userDirs = {

        enable = true; ## own $XDG_CONFIG_HOME/user-dirs.dirs
        createDirectories = true;
        desktop = "~";
        download = "~/download";
        documents = "~";
        music = "~";
        pictures = "~/pictures";
        publicShare = "~";
        templates = "~";
      };
      cacheHome = homePath + "/.cache";
      configHome = homePath + "/.config";
      dataHome = homePath + "/.local/share";
      stateHome = homePath + "/.local/state";

      mime.enable = true;
      mimeApps.enable = false; # handles manually in 

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



    };
}





