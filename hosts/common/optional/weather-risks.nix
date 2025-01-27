# temporary for school project
{
  inputs,
  lib,
  ...
}: let
  port = 45825;
  directory = "/var/lib/weather-risks";
in {
  systemd.services.weather-risks = {
    description = "Weather Risks";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = lib.getExe' inputs.weather-risks.packages.x86_64-linux.default "weather_risks";
      Restart = "always";
      RestartSec = 5;
      User = "weather-risks";
      Group = "weather-risks";
    };
    environment = {
      WEATHER_RISKS_PORT = toString port;
      WEATHER_RISKS_RELOAD = "false";
      XDG_CACHE_HOME = "${directory}/cache";
    };
  };

  environment.persistence."/persist/nobackup".directories = [
    {
      inherit directory;
      user = "weather-risks";
      group = "weather-risks";
      mode = "0700";
    }
  ];

  users.users.weather-risks = {
    isSystemUser = true;
    home = directory;
    group = "weather-risks";
    createHome = true;
  };

  users.groups.weather-risks = {};

  services.nginx.virtualHosts."weather-risks.bizel.fr" = {
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
    useACMEHost = "bizel.fr";
  };
}
