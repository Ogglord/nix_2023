{ pkgs, lib, ... }:
{

  gtk.theme.package = lib.mkForce pkgs.gnome.gnome-themes-extra;
  gtk.theme.name = lib.mkForce "Adwaita";
  gtk.iconTheme.package = lib.mkForce pkgs.gnome.adwaita-icon-theme;
  gtk.iconTheme.name = lib.mkForce "Adwaita";
}
