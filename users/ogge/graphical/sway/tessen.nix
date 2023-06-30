{ pkgs, ... }:
{
  home.file.".config/tessen/config".text = ''
    pass_backend="gopass"
    dmenu_backend="rofi"
    action="autotype"
    rofi_config_file="$XDG_CONFIG_HOME/rofi/config.rasi"
    userkey="(user|login)"
    web_browser="brave"
    notify="true"
  '';
  home.packages = [ pkgs.tessen ];
}
