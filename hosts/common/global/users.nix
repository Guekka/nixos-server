{
  pkgs,
  config,
  ...
}: {
  programs.fish.enable = true;
  users = {
    mutableUsers = false;
    users = {
      edgar = {
        isNormalUser = true;
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ4dwdR5kG7RApFSuqiy11IoRG0pECnMLbiLLfttpwJ beelink"];
        hashedPasswordFile = config.sops.secrets.edgar-password.path;

        extraGroups = let
          ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
        in
          [
            "dialout"
            "wheel"
            "video"
            "audio"
          ]
          ++ ifTheyExist [
            "gamemode"
            "network"
            "wireshark"
            "i2c"
            "mysql"
            "docker"
            "podman"
            "git"
            "libvirtd"
            "deluge"
          ];
      };
      root = {
        # so, this may look like a security issue. I'm publicly showing the hash of my password. However:
        # 1. this password is extremely robust (~2000 bits of entropy)
        # 2. it is not used anywhere else
        # 3. it cannot be used to login over ssh
        # considering the odds of someone stealing my computer AND knowing how to crack this, I feel safe enough to put it here
        hashedPassword = "$6$3Wb/r3HjvDIFx0zA$FVqsrOpvnkkXDox8.CfNM1WhbJje4/Cji49igfegKrrooavDaCzYFZkthVBmfOo/Iqi6jhhgCmKpUqiKRQh/./";
      };
    };
  };

  sops.secrets.edgar-password = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.edgar = import home/${config.networking.hostName}.nix;

  security.pam.services.hyprlock = {};
  security.pam.services.swaylock = {};

  # There's a HM module for sops-nix, but it does not seem practical. TODO investigate it
  sops.secrets.atuin_key = {
    sopsFile = ../secrets.yaml;
    path = "/home/edgar/secrets/atuin_key";
    owner = "edgar";
  };

  sops.secrets.atuin_session = {
    sopsFile = ../secrets.yaml;
    path = "/home/edgar/secrets/atuin_session";
    owner = "edgar";
  };

  sops.secrets.nextcloud_pass = {
    sopsFile = ../secrets.yaml;
    path = "/home/edgar/secrets/nextcloud_pass";
    owner = "edgar";
  };

  sops.secrets.wakatime_cfg = {
    sopsFile = ../secrets.yaml;
    path = "/home/edgar/.wakatime.cfg";
    owner = "edgar";
  };

  sops.secrets.winapps-config = {
    sopsFile = ../secrets.yaml;
    # it is not possible to put it directly into .config, as sops would create the parent dir
    # with root ownership
    path = "/home/edgar/secrets/winapps.conf";
    owner = "edgar";
  };
}
