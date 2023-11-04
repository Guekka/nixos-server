{
  pkgs,
  config,
  ...
}: let
  passwordFile = "/persist/passwords/edgar";
in {
  programs.fish.enable = true;
  users = {
    mutableUsers = false;
    users = {
      edgar = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ4dwdR5kG7RApFSuqiy11IoRG0pECnMLbiLLfttpwJ beelink"];

        initialHashedPassword = "$6$HKQ5ZEb2wSnYtBGo$/Y4Fh7xHbeQ9p9VL6zyXkk1CCyN/XADveDddYtWr8KHP5vF/bWT9/Xs4cBBhrstp8s6Q.ak5GbOPd2yni/pYJ0";
        hashedPasswordFile = passwordFile;
      };
    };
  };

  home-manager.users.edgar = import home/${config.networking.hostName}.nix;

  security.pam.services.swaylock = {};

  # I've locked myself out of my computer too many times when the password file doesn't exist
  # So create a default one
  system.activationScripts.createDefaultPasswordFile = ''
    mkdir -p /persist/passwords
    # only create the file if it doesn't exist. Password is "hunter2"
    if [ ! -f ${passwordFile} ]; then
      echo "${passwordFile} doesn't exist, creating it. Password is \"hunter2\""
      echo '$6$bH8SwzNFISaaeQ6g$anQ2PpZy1l8Mkr/TeDgLnOqchTnR9yHA1Pfh0o1HP8KFk4B4Ei6mhGRmyV/0fa.k9jkBJf2sz97OUOhNLdMPn/' > ${passwordFile}
      # what if the update users script runs before this one? Let's change the password in case
      yes hunter2 | passwd edgar
    fi
  '';

  # Home secrets. I guess the proper way would be to use the home manager module
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
}
