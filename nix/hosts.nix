let
  hosts = {
    ogge = {
      type = "nixos"; # nixos/homeManager
      address = "100.69.178.40";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4NsULMpfxxTtSlLrvyBcfEAuBXxFgNTrvd5QDjtXZd";
      remoteBuild = false;
    };
    batu = {
      type = "nixos";
      address = "194.87.149.71";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4NsULMpfxxTtSlLrvyBcfEAuBXxFgNTrvd5QDjtXZd";
      remoteBuild = true;
    };
    # insurely = {
    #   type = "homeManager";
    #   hostPlatform = "aarch64-darwin";
    #   homeDirectory = "/home/ogge";
    # };
   
  };

  inherit (builtins) attrNames concatMap listToAttrs;

  filterAttrs = pred: set:
    listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

  removeEmptyAttrs = filterAttrs (_: v: v != { });

  genSystemGroups = hosts:
    let
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      systemHostGroup = name: {
        inherit name;
        value = filterAttrs (_: host: host.hostPlatform == name) hosts;
      };
    in
    removeEmptyAttrs (listToAttrs (map systemHostGroup systems));

  genTypeGroups = hosts:
    let
      types = [ "darwin" "homeManager" "nixos" ];
      typeHostGroup = name: {
        inherit name;
        value = filterAttrs (_: host: host.type == name) hosts;
      };
    in
    removeEmptyAttrs (listToAttrs (map typeHostGroup types));

  genHostGroups = hosts:
    let
      all = hosts;
      systemGroups = genSystemGroups all;
      typeGroups = genTypeGroups all;
    in
    all // systemGroups // typeGroups // { inherit all; };
in
genHostGroups hosts