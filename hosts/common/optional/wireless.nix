{ config, lib, ... }: {
  # Wireless secrets stored through sops
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  networking.wireless = {
    enable = true;
    scanOnLowSignal = false; # reduce battery usage
    # Declarative
    environmentFile = config.sops.secrets.wireless.path;
    networks = {
      "SFR_E358" = {
        pskRaw = "@SFR_E358@";
      };
      "SFR_E358_5GHZ" = {
        pskRaw = "@SFR_E358@";
      };
      "eduroam" = {
        auth = ''
          key_mgmt=WPA-EAP
          eap=PWD
          identity="@EDUROAM_MAIL@"
          password="@EDUROAM@"
        '';
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      update_config=1
    '';
  };

  # Ensure group exists
  users.groups.network = { };

  # Persist imperative config
  environment.persistence = {
    "/persist".files = [
      "/etc/wpa_supplicant.conf"
    ];
  };
}
