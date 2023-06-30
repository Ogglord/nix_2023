Ogglord's NixOS Configurations
=======================

NixOS is an advanced GNU/Linux distribution featuring declarative configuration, reproducible builds and atomic upgrades. You can learn more at [nixos.org](https://nixos.org/).

In this repository are the configurations of my NixOS machines.

You can find the configurations from other people in the [nixos.wiki](https://nixos.wiki/wiki/Configuration_Collection).

## Usage

```bash
sudo nixos-rebuild build --flake '.#hostname'
```


```bash
home-manager build --flake '.#username@hostname'
```

## Desktop setup
 - wayland
 - sway
 - secureboot
 - btrfs

### For cloud machines
 - remote build for cloud using nixos-anywhere

