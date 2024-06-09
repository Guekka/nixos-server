{
  config,
  lib,
  pkgs,
  ...
}: let
  exclude_patterns = [
    "**/.git"
    "**/*.pyc"
    "/home/*/.direnv"
    "/home/*/.cache"
    "/home/*/.config/Code"
    "/home/*/.config/heroic"
    "/home/*/.config/Beeper"
    "/home/*/.config/chromium"
    "/home/*/.config/discord"
    "/home/*/.config/obsidian"
    "/home/*/.config/Ledger Live"
    "/home/*/.config/VSCodium"
    "/home/*/.config/vesktop"
    "/home/*/.local/share/Trash"
    "/home/*/.local/share/lutris"
    "/home/*/.local/share/containers"
    "/home/*/.local/share/JetBrains"
    "/home/*/.local/share/pnpm"
    "/home/*/.local/share/proton"
    "/home/*/.local/share/Steam"
    "/home/*/.npm"
    "/home/*/.m2"
    "/home/*/.gradle"
    "/home/*/.opam"
    "/home/*/.clangd"
    "/home/*/.mozilla/firefox/*/storage"
    "/home/*/.vcpkg"
    "/home/*/.vscode"
    "/home/*/Android"
    # all my code is in VCS
    "/home/*/code"
    "/home/*/Downloads"
    "/home/*/Games"
    "/home/*/Nextcloud"
    "/home/*/Unity/Hub"
    "/persist/var/lib/containers"
    "/persist/swapfile"
  ];

  baseConfig = {
    inherit exclude_patterns;

    compression = "auto,zstd,10";
    relocated_repo_access_is_ok = true;

    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 6;
    keep_yearly = 1;

    checks = [
      {
        name = "repository";
      }
    ];

    ssh_command = "${pkgs.openssh}/bin/ssh -oBatchMode=yes -i ${config.sops.secrets.guekka-backup-domino-ssh.path}";

    healthchecks.ping_url = "https://hc-ping.com/5546438b-6945-4e1e-93cf-31338745aab4";
  };
in {
  services.borgmatic = {
    enable = true;
    configurations =
      {
        "default" =
          baseConfig
          // {
            repositories = [
              # TODO: investigate why the NAS crashes
              /*
              {
                label = "samba-${config.networking.hostName}";
                path = "/samba/borg/${config.networking.hostName}";
              }
              */
              {
                label = "ssh-${config.networking.hostName}";
                path = "ssh://guekka-backup@domino.zdimension.fr/./${config.networking.hostName}";
              }
            ];
            source_directories = [
              "/persist"
              "/home"
            ];

            encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."${config.networking.hostName}-borgbackup-passphrase".path}";
          };
      }
      //
      # TODO: maybe move this to a separate file
      lib.optionalAttrs (config.networking.hostName == "horus")
      {
        "shared" =
          baseConfig
          // {
            repositories = [
              # TODO: investigate why the NAS crashes
              /*
              {
                label = "samba-shared";
                path = "/samba/borg/shared";
              }
              */
              {
                label = "ssh-shared";
                path = "ssh://guekka-backup@domino.zdimension.fr/./shared";
              }
            ];
            source_directories = [
              "/shared"
            ];

            encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.shared-borgbackup-passphrase.path}";
          };
      };
  };

  sops.secrets.guekka-backup-domino-ssh.sopsFile = ../secrets.yaml;

  systemd.timers.borgmatic = {
    enable = true;
    description = "borgmatic backup";
    wantedBy = ["timers.target"];
    timerConfig = {
      Unit = "borgmatic.service";
      OnCalendar = "*-*-* 00:00:00";
      Persistent = true;
      WakeSystem = true;
    };
  };
}
