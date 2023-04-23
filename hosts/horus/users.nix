let
  mkUser = user: key: {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [key];
    passwordFile = "/persist/passwords/${user}";
  };
in {
  users.users = {
    maxime = mkUser "maxime" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPspfyaUsaq6jiwQ5mjz4d6Zfd30B7VUOvzqllV0UaFo ozeliurs@gmail.com";
    tom = mkUser "tom" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPoGjjQkOBXDqWS7Sx0cFe+rks6dYkVVt+DgH5Ze0FRj tombe@LAPTOP-O2I1684M";
    raphael = mkUser "raphael" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICacN1gCNo4bsV9WsZ84ZQQvfs+AfcvYBWzTWhJwqHnJ raphaelanjou@MacBook-Pro-Raphael-Anjou.local";
    apoorva = mkUser "apoorva" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPutUy6DkcaM3pP/lcCWdsuNE9czLHJQPF3FrZx/KKUr appad@LAPTOP-V040VGK2";
  };
}
