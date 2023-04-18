{
  users.mutableUsers = false;
  users.users = {
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ4dwdR5kG7RApFSuqiy11IoRG0pECnMLbiLLfttpwJ beelink" ];

      # passwordFile needs to be in a volume marked with `neededForBoot = true`
      passwordFile = "/persist/passwords/user";
    };
    maxime = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPspfyaUsaq6jiwQ5mjz4d6Zfd30B7VUOvzqllV0UaFo ozeliurs@gmail.com" ];
      passwordFile = "/persist/passwords/maxime";
    };
    tom = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPoGjjQkOBXDqWS7Sx0cFe+rks6dYkVVt+DgH5Ze0FRj tombe@LAPTOP-O2I1684M" ];
      passwordFile = "/persist/passwords/tom";
    };
    raphael = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICacN1gCNo4bsV9WsZ84ZQQvfs+AfcvYBWzTWhJwqHnJ raphaelanjou@MacBook-Pro-Raphael-Anjou.local" ];
      passwordFile = "/persist/passwords/raphael";
    };
    apoorva = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPutUy6DkcaM3pP/lcCWdsuNE9czLHJQPF3FrZx/KKUr appad@LAPTOP-V040VGK2" ];
      passwordFile = "/persist/passwords/apoorva";
    };
  };
}
