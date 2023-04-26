{pkgs}: {
  users = {
    mutableUsers = false;
    users = {
      edgar = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ4dwdR5kG7RApFSuqiy11IoRG0pECnMLbiLLfttpwJ beelink"];
        passwordFile = "/persist/passwords/edgar";
      };
    };
  };
}
