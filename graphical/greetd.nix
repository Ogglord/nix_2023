{ pkgs, lib, ... }:
let
  swayRun = pkgs.writeShellScript "sway-run" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway

    # more wayland stuff
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export NIXOS_OZONE_WL=1

    systemd-run --user --scope --collect --quiet --unit=sway systemd-cat --identifier=sway ${pkgs.swayfx}/bin/sway $@
  '';
in
{

  environment.systemPackages = [ pkgs.greetd.tuigreet ];

  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "${lib.makeBinPath [pkgs.greetd.tuigreet] }/tuigreet --time --cmd ${swayRun}";
        #user = "greeter";
      };
      # autologin ?
      #initial_session = {
      #  command = "${swayRun}";
      #  user = "ogge";
      #};
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
