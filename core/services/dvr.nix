{ pkgs, ... }:
let
  baseDir = "/var/lib/qbittorrent";
in
{
  services.sonarr = {
    enable = true;
    openFirewall = false;
  };
  services.radarr = {
    enable = true;
    openFirewall = false;
  };

  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];

  systemd.tmpfiles.rules = [
    "d '${baseDir}' 0700 qbittorrent qbittorrent - -"
  ];

  users.extraGroups.qbittorrent = { };

  users.extraUsers.qbittorrent =
    {
      description = "qbittorrent";
      group = "qbittorrent";
      home = baseDir;
      isSystemUser = true;
    };

  systemd.services.qbittorrent-nox = {
    description = "qBittorrent-nox service for user qbittorrent";
    documentation = [ "man:qbittorrent-nox(1)" ];
    wants = [ "network-online.target" ];
    after = [ "local-fs.target" "network-online.target" "nss-lookup.target" ];
    wantedBy = [ "default.target" ];
    preStart = ''
      mkdir -p ${baseDir}
      chown qbittorrent.qbittorrent ${baseDir}
      chmod 0750 ${baseDir}
    '';
    serviceConfig = {
      Type = "simple";
      PrivateTmp = "false";
      User = "qbittorrent";
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
      TimeoutStopSec = 1800;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22560 ]; # set manually in qbittorrent
  networking.firewall.allowedUDPPorts = [ 22560 ]; # set manually in qbittorrent
}
