{ config, lib, pkgs, ... }:
with lib;
let
  # the values of the options set for the service by the user of the service
  cfg = config.programs.autobrr;

  settingsFormat = pkgs.formats.toml { };

  settingsFile = settingsFormat.generate "config.toml" cfg.settings;
in
{
  ##### interface. here we define the options that users of our service can specify
  options = {
    # the options for our service will be located under programs.autobrr in home-manager
    programs.autobrr = rec  {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable autobrr service.
        '';
      };

      package = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "The autobrr package to use.";
      };

      settings = mkOption {
        inherit (settingsFormat) type;
        default = { };
        description = lib.mdDoc ''
          Configuration included in `config.toml`.

          See https://autobrr.com/configuration/autobrr for documentation.
        '';
      };

      configPath = mkOption {
        type = types.str;
        default = "/autobrr"; # require this, as this is not a home manager module, we are not aware of user
        description = ''
          The config path option for autobrr, relative to XDG_CONFIG_HOME.
        '';
      };

      systemd.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable systemd user-level service.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "";
        description = ''
          user to run systemd service as.
        '';
      };
      group = mkOption {
        type = types.str;
        default = "";
        description = ''
          group to run systemd service as.
        '';
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable {
    # only apply the following settings if enabled
    # configure systemd services
    # add package to system

    programs.autobrr.package = mkDefault pkgs.autobrr;
    programs.autobrr.user = mkDefault config.home.username;
    programs.autobrr.group = mkDefault config.home.group;

    home.packages = [ cfg.package ];

    xdg.configFile."${cfg.configPath}/config.toml".source = settingsFile;

    systemd.user.services.autobrr = mkIf cfg.systemd.enable
      {
        Unit = {
          Description = "autobrr service";
          After = [ "network.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];

        };
        Service =
          {
            Type = "simple";
            ExecStart = "${cfg.package}/bin/autobrr --config=${config.xdg.configHome + cfg.configPath}";
            Restart = "always";
          };
      };
  };
}
