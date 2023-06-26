{ pkgs, lib, ... }:
{
  # Use lanzaboote and secureboot  
  boot = {
    bootspec.enable = true;
    kernelPackages = pkgs.linuxPackages_latest; ## latest kernel
    tmp.cleanOnBoot = true; ## empty /tmp on boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.consoleMode = "max";
    loader.systemd-boot.configurationLimit = 5;
    loader.timeout = 0;
    ## qiet boot please
    plymouth.enable = true;
    plymouth.theme = "breeze";
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" ]; #"rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
  };
  ## TTY
  #services.kmscon =
  #  {
  #    enable = true;
  #    hwRender = true;
  #extraConfig =
  #  ''
  #    font-name=Lat2-Terminus16
  #    font-size=14
  #  '';
  #  };

}
