Ogglord's NixOS Configurations
=======================

NixOS is an advanced GNU/Linux distribution featuring declarative configuration, reproducible builds and atomic upgrades. You can learn more at [nixos.org](https://nixos.org/).

In this repository are the configurations of my NixOS machines.

You can find the configurations from other people in the [nixos.wiki](https://nixos.wiki/wiki/Configuration_Collection).

## Usage

A `host` is built using one reference, if the hostType is nixos then this includes setting up the home-manager configuration as well.
```bash
sudo nixos-rebuild build --flake '.#host'
```

Hosts are defined as types of either `nixos`, `darwin` or `home-manager` (standalone). They are listed in `/nix/hosts.nix`

## Quick locations

System packages: [/core/default.nix](/core/default.nix)\
User packages: [/users/[user]/core/default.nix](/users/ogge/core/default.nix)



## Host: **Desktop**
 - wayland
 - sway
 - secureboot
 - btrfs

### For cloud machines
 - remote build for cloud using nixos-anywhere

