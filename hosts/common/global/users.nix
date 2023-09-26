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
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ4dwdR5kG7RApFSuqiy11IoRG0pECnMLbiLLfttpwJ beelink"];
        hashedPasswordFile = "/persist/passwords/edgar";
      };
    };
  };

  home-manager.users.edgar = import home/${config.networking.hostName}.nix;

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
