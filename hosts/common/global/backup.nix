{config, ...}: let
  baseJob = {
    exclude = [
      "*.pyc"
      "/home/*/.direnv"
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
      "/home/*/.local/share/lutris"
      "/home/*/.local/share/containers"
      "/home/*/.local/share/proton"
      "/home/*/.local/share/Steam"
      "/home/*/.npm"
      "/home/*/.m2"
      "/home/*/.gradle"
      "/home/*/.opam"
      "/home/*/.clangd"
      "/home/*/.config/Ferdium/Partitions"
      "/home/*/.mozilla/firefox/*/storage"
      "/home/*/Android"
      "/home/*/Downloads"
      "/home/*/Games"
      "/home/*/Unity/Hub"
      "swapfile"
    ];
    encryption = {
      mode = "repokey";
      passCommand = "cat ${config.sops.secrets."${config.networking.hostName}-borgbackup-passphrase".path}";
    };
    compression = "auto,zstd";
    startAt = "daily";
    preHook = "set -x";

    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = 0;
    };
  };
in {
  services.borgbackup.jobs = {
    ${config.networking.hostName} =
      baseJob
      // {
        paths = [
          "/persist"
          "/home"
        ];
        repo = "/samba/borg/${config.networking.hostName}";
      };

    shared =
      baseJob
      // {
        paths = [
          "/shared"
        ];
        repo = "/samba/borg/shared";
        encryption = {
          mode = "repokey";
          passCommand = "cat ${config.sops.secrets.shared-borgbackup-passphrase.path}";
        };
      };
  };
}
