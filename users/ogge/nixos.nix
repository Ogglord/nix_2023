{ config, lib, pkgs, ... }:
with lib;
{
  #age.secrets.oggePassword.file = ./password.age;
  #imports = optionals
  #  config.programs.sway.enable
  #  [ ./graphical/steam.nix ];
  imports = [ ./graphical/steam.nix ];
  users.groups.ogge.gid = config.users.users.ogge.uid;

  users.users.ogge = {
    createHome = true;
    description = "Ogglord";
    group = "ogge";
    extraGroups = [ "wheel" ]
      ++ optionals config.hardware.i2c.enable [ "i2c" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.programs.sway.enable [ "input" "video" ]
      ++ optionals config.services.unbound.enable [ "unbound" ]
      ++ optionals config.sound.enable [ "audio" ]
      ++ optionals config.virtualisation.docker.enable [ "docker" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.kvmgt.enable [ "kvm" ]
      ++ optionals config.virtualisation.podman.enable [ "podman" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4NsULMpfxxTtSlLrvyBcfEAuBXxFgNTrvd5QDjtXZd default"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWX4zp7ZFi3au4GfaMi2pOgtX9gUUw8gsykQKDt8KtG8Y9TQnmTKqXSr/WlxO9FScBVSd91269lKqGf4jyLopN+nRjr7vfQcDtm70NNeH3Z48feMOpfBOv4g2ntn4q/lJxktHe2cGSX5V0SHNTEd+LKC+cHjokITxkiS6VyWyrB40JrQW2U5aOrABVto5gDunsSbyPvNyNwQCOL+5cAaOjDn+1G6kg9+TXZrqh8KeB0lJddDWvWjlW/CxRymvgMTBvL/EjghlNMfr91hTGiUpeFIJOAqNsfgnHu/SMLUB9D0LiZ20YTvG61tb+4tyzm96nAftz6iNT3Nj+N/FEnywqbpFGZ5D8FY623Y0g1g7+VxoxhkErcbnQB9jR2aTFZm00y3WgpxquISfzJFmyOSGAPjCLn4KMPfclwuZfH/7T2gLHkrmr046QqPpBSpWc6AvBQllML7e9L5UavFCFvySp3kRPZj5cp3jyjAxZq9vHpex3FxM0tTxAK+ReMjm2fec= ogge@ogge"
    ];
    shell = pkgs.zsh;
    uid = 1000;

    #passwordFile = config.age.secrets.oggePassword.path;
  };

  programs._1password-gui.polkitPolicyOwners = [ "ogge" ];

  home-manager.users.ogge = {
    imports = optionals config.programs.sway.enable [
      ./graphical
      ./graphical/sway
    ] ++ optionals config.services.xserver.windowManager.i3.enable [
      ./graphical
      ./graphical/i3
    ];
  };
}
