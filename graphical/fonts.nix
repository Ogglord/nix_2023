{ hostType, lib, pkgs, ... }: {
  fonts =
    {
      fontDir.enable = hostType == "darwin";
      fonts = with pkgs; [
        # FIXME: Make nix-darwin stop exploding when there are repeated fonts
        # dejavu_fonts
        # noto-fonts-extra
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        unifont
        (nerdfonts.override { fonts = [ "Hack" "Iosevka" ]; })
        #meslo-lgs-nf
        #roboto
        ubuntu_font_family
        ibm-plex
      ];
    };
  # // lib.optionalAttrs (hostType == "nixos") {
  #   enableDefaultFonts = false;
  #   enableGhostscriptFonts = false;
  #   fontconfig = {
  #     localConf = ''
  #       <?xml version="1.0"?>
  #       <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
  #       <fontconfig>
  #           <alias binding="weak">
  #               <family>monospace</family>
  #               <prefer>
  #                   <family>emoji</family>
  #               </prefer>
  #           </alias>
  #           <alias binding="weak">
  #               <family>sans-serif</family>
  #               <prefer>
  #                   <family>emoji</family>
  #               </prefer>
  #           </alias>
  #           <alias binding="weak">
  #               <family>serif</family>
  #               <prefer>
  #                   <family>emoji</family>
  #               </prefer>
  #           </alias>
  #       </fontconfig>
  #     '';
  #   };
  # };


}
