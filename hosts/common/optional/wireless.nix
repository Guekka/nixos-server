{
  networking.networkmanager.enable = true;

  environment.persistence."/persist/backup" = {
    directories = ["/etc/NetworkManager/system-connections"];
  };
}
