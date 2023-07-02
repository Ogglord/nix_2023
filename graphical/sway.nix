{ pkgs, ... }:
{
  ## disabled, since it doesnt work with swayfx + home-manager
  programs.sway = {
    enable = false;
    package = pkgs.swayfx;
    extraPackages = with pkgs; [

    ];
  };
}
