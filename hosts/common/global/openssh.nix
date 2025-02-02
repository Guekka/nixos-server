{
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = false;
    };

    hostKeys = [
      {
        path = "/persist/backup/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding yes
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
