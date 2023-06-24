{ pkgs, lib, ... }:
{
  imports = [ ];
  
  programs.wofi = {
    enable = true;
    settings = {
      width = 1200;
      height = 800;
      mode = "drun";
      filter_rate = 100;
      term = "alacritty";
      allow_markup = true;
      allow_images = true;
      prompt = "Sök";
      hide_scroll = true;
      insensitive = true;
      no_actions = true;      
    };
    style = builtins.readFile ./alt_style.css;
    
  };

}