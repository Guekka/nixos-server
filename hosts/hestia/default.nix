{...}: {
  imports = [
    ../common/global
    ../common/optional/android-connect.nix
    ../common/optional/bluetooth.nix
    ../common/optional/brightness.nix
    ../common/optional/docker.nix
    ../common/optional/gamescope.nix
    ../common/optional/hyprland.nix
    ../common/optional/impermanence.nix
    ../common/optional/ledger.nix
    ../common/optional/nfs-client.nix
    ../common/optional/noisetorch.nix
    ../common/optional/obs-virtual-camera.nix
    ../common/optional/openocd.nix
    ../common/optional/pipewire.nix
    ../common/optional/samba-client.nix
    ../common/optional/steam.nix
    ../common/optional/thunar.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "hestia";
    interfaces.enp42s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
    firewall.allowedTCPPorts = [5900];
  };

  services.tailscaleAutoconnect = {
    advertiseExitNode = false;
    exitNode = "horus";
    exitNodeAllowLanAccess = true;
  };

  time.timeZone = "Europe/Amsterdam";

  sops.secrets.hestia-borgbackup-passphrase.sopsFile = ./secrets.yaml;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["edgar"];
}
