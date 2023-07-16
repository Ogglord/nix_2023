{ ... }:
{
  ## enable autobrr
  programs.autobrr = {
    enable = true;
    systemd.enable = true;
    settings = {
      host = "0.0.0.0";
      port = 7474;
      #logPath = "autobrr.log";
      logLevel = "DEBUG";
      sessionSecret = "670b0de2d20a7709a7982ae283732829";
    };
  };
}

