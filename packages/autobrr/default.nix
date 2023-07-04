{ pkgs ? import <nixpkgs> { } }:
pkgs.callPackage ./autobrr.nix { }
