{ lib, bootType, hostName, hostType, extraRoles, ... }:
builtins.seq (lib.debug.traceSeq rec {host = hostName; boot = bootType; type = hostType; roles = extraRoles;} null) {

  imports = [];
}
    

  