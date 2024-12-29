{
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  environment.persistence."/persist".directories = ["/var/lib/bluetooth"];
}
