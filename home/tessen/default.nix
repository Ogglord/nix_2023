{ pkgs, ... }:
{
  home.file.".config/tessen/config".source = ./config.toml;
  home.packages = [ pkgs.tessen ];
}
