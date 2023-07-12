{ config, lib, pkgs, ... }:
with lib;  # use the functions from lib, such as mkIf
let
  # the values of the options set for the service by the user of the service
  cfg = config.services.autobrr;
  env =
    {
      VARIABLE = "VALUE";
    };
in
{
  ##### interface. here we define the options that users of our service can specify
  options = {
    # the options for our service will be located under services.foo
    services.autobrr = rec  {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable autobrr service.
        '';
      };

      package = mkOption {
        type = types.path;
        description = "The autobrr package.";
      };

      configFile = mkOption {
        type = types.path;
        default = "/";
        description = ''
          The config file option for autobrr.
        '';
      };

      configFilePath = mkOption {
        type = types.str;
        default = "/";
        description = ''
          The config file path option for autobrr.
        '';
      };

      systemd.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable systemd service.
        '';
      };

      runAsUser = mkOption {
        type = types.str;
        default = "root";
        description = ''
          user to run systemd service as.
        '';
      };
      runAsGroup = mkOption {
        type = types.str;
        default = "root";
        description = ''
          group to run systemd service as.
        '';
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable {
    # only apply the following settings if enabled
    # here all options that can be specified in configuration.nix may be used
    # configure systemd services
    # add system users
    # write config files, just as an example here:
    environment.systemPackages = [ cfg.package ];

    systemd.services.autobrr = mkIf cfg.systemd.enable
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        environment = env;
        serviceConfig =
          {
            Type = "simple";
            ExecStart = "@${cfg.package}/bin/autobrr --config=${cfg.configFilePath}";
            User = "${cfg.runAsUser}";
            Group = "${cfg.runAsGroup}";
            Restart = "always";
          };
      };
  };
}
