{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    # Additional options for the git program
    package = pkgs.gitAndTools.gitFull; # Install git wiith all the optional extras
    userName = "ogglord";
    userEmail = "oag@proton.me";
    extraConfig = {
      # Use vim as our default git editor
      core.editor = "nano";
      # Cache git credentials for 15 minutes
      credential.helper = "cache";
    };
  };
}
