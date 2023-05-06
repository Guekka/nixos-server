{
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  environment.persistence."/persist" = {
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [22];
  };
}
