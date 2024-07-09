{config, ...}: {
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.bizel.fr";

    config = {
      prejoinPageEnabled = true;
      disableModeratorIndicator = true;
    };
  };

  services.nginx.virtualHosts.${config.services.jitsi-meet.hostName} = {
    enableACME = false;
    useACMEHost = "bizel.fr";
  };

  services.jitsi-videobridge.openFirewall = true;
}
