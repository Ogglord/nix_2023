{ pkgs, ... }:
{
  ## this is enough to enable the configuration on user basis
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraPackages = with pkgs; [

    ];
  };
}
