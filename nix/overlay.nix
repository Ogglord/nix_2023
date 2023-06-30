{ agenix
  #q, nix
, nixpkgs
, nixpkgs-wayland
, ...
}:

let
  inherit (nixpkgs) lib;
  localOverlays =
    lib.mapAttrs'
      (f: _: lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (import (./overlays + "/${f}")))
      (builtins.readDir ./overlays);

in
localOverlays // {
  default = lib.composeManyExtensions
    ([
      agenix.overlays.default
      nixpkgs-wayland.overlay
      #deploy-rs.overlay
      #nix.overlays.default
    ] ++ (lib.attrValues localOverlays));
}
