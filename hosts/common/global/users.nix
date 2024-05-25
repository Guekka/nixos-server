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
            "wheel"
            "video"
            "audio"
          ]
          ++ ifTheyExist [
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
        # 1. this password is very robust
        # 2. it is not used anywhere else
        # 3. it only works if you have stolen my computer
        # considering the odds of someone stealing my computer AND knowing how to crack this, I feel safe enough to put it here
        hashedPassword = "$6$pOQ6iRJO9Fq.FMVq$qFoIq4gCC/KPO.o4CAXqSafv4drCKJJFTr6tW98sBUi1QWYxDFwQlwQHO.m3p2tMfGwSPsbDeiEQQDtHFVn8Y.";
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

  # But it seems too tedious
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
}
