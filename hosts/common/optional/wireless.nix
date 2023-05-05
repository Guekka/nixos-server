{
  networking.networkmanager.enable = true;

  environment.persistence."/persist" = {
    directories = ["/etc/NetworkManager/system-connections"];
  };
}
