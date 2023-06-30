{ ... }:
{
  ## resolution profile mgmt
  services.kanshi = {
    enable = true;
    #systemdTarget = "sway-session.target";
    systemdTarget = "";
    profiles = {
      normal = {
        outputs = [
          #{
          #  criteria = "DP-2";
          #  status = "disable";
          #}
          {
            criteria = "DP-2";
            position = "0,0";
            mode = "2560x1440@240Hz";
          }
        ];
      };
    };
  };
}
