{
  config,
  pkgs,
  ...
}: {
  # enable the tailscale service
  services.tailscale.enable = true;

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up --authkey $(cat ${config.sops.secrets.tailscale_key.path}) --login-server https://headscale.ozeliurs.com --advertise-exit-node
    '';
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  # Open ports in the firewall.
  networking.firewall = {
    # always allow traffic from your Tailscale network
    trustedInterfaces = ["tailscale0"];

    allowedUDPPorts = [config.services.tailscale.port];

    checkReversePath = "loose";
  };

  # for exit node
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  sops.secrets.tailscale_key = {
    sopsFile = ../secrets.yaml;
  };

  environment.persistence = {
    "/persist".directories = ["/var/lib/tailscale"];
  };
}
