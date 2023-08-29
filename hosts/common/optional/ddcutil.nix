{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.ddcutil
  ];
  hardware.i2c.enable = true;

  # fix https://github.com/NixOS/nixpkgs/issues/210856
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "i2c-udev-rules";
      text = ''ACTION=="add", KERNEL=="i2c-[0-9]*", TAG+="uaccess"'';
      destination = "/etc/udev/rules.d/70-i2c.rules";
    })
  ];
}
