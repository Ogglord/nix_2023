{ pkgs ? import <nixpkgs> { }, ... }:
#pkgs.callPackage ./autobrr/autobrr.nix { }
{
  imports = [ ./autobrr/autobrr.nix ];
}
