{ pkgs, lib, bootType, ... }:
{
  # Use lanzaboote and secureboot  
  boot = lib.mkIf (bootType == "secureboot") {
    bootspec.enable = true;
    kernelPackages = pkgs.linuxPackages_latest; ## latest kernel
    tmp.cleanOnBoot = true; ## empty /tmp on boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader.grub.enable = lib.mkForce false;
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.consoleMode = "max";
    loader.systemd-boot.configurationLimit = 5;
    loader.timeout = 0;

  };

  environment.systemPackages = with pkgs; [ sbctl ];

}
