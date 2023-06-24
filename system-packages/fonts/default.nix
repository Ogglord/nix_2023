{ pkgs, ... }:
{

  # Fonts
  fonts = {
    #enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
      roboto
      ubuntu_font_family
      noto-fonts-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Roboto Slab" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Hack Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

}
