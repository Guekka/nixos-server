{
  config,
  pkgs,
  ...
}: let
  # TODO: update exclude patterns
  exclude_patterns = [
    "**/.git"
    "**/*.pyc"
    # freedesktop trash
    "**/.Trash"
    "**/.Trash-?"
    "/persist/backup/home/*/.config/.android"
    "/persist/backup/home/*/.config/Code"
    "/persist/backup/home/*/.config/heroic"
    "/persist/backup/home/*/.config/chromium"
    "/persist/backup/home/*/.config/obsidian"
    "/persist/backup/home/*/.config/VSCodium"
    "/persist/backup/home/*/.config/vesktop"
    "/persist/backup/home/*/.local/share/Trash"
    "/persist/backup/home/*/.local/share/containers"
    "/persist/backup/home/*/.local/share/JetBrains"
    "/persist/backup/home/*/.local/share/pnpm"
    "/persist/backup/home/*/.local/share/proton"
    "/persist/backup/home/*/.npm"
    "/persist/backup/home/*/.m2"
    "/persist/backup/home/*/.gradle"
    "/persist/backup/home/*/.opam"
    "/persist/backup/home/*/.clangd"
    "/persist/backup/home/*/.mozilla/firefox/*/storage"
    "/persist/backup/home/*/.vcpkg"
    "/persist/backup/home/*/.vscode"
    "/persist/backup/home/*/Android"
    "/persist/backup/home/*/Unity/Hub"
  ];

  baseConfig = {
    inherit exclude_patterns;
    exclude_if_present = [".nobackup" "CACHEDIR.tag"];

    compression = "auto,zstd,10";
    relocated_repo_access_is_ok = true;

    keep_daily = 3;
    keep_weekly = 2;
    keep_monthly = 3;
    keep_yearly = 1;

    checks = [
      {
        name = "repository";
      }
      {
        name = "spot";
        frequency = "1 week";
        count_tolerance_percentage = 10;
        data_sample_percentage = 10;
        data_tolerance_percentage = 0.5;
        xxh64sum_command = pkgs.writeShellScript "xxhash64" ''
          exec ${pkgs.xxHash}/bin/xxhsum -H64 "$1"
        '';
      }
    ];

    ssh_command = "${pkgs.openssh}/bin/ssh -oBatchMode=yes -i ${config.sops.secrets.guekka-backup-domino-ssh.path}";

    healthchecks.ping_url = "https://hc-ping.com/5546438b-6945-4e1e-93cf-31338745aab4";
  };
in {
  services.borgmatic = {
    enable = true;
    configurations = {
      "default" =
        baseConfig
        // {
          repositories = [
            {
              label = "ssh-${config.networking.hostName}";
              path = "ssh://guekka-backup@domino.zdimension.fr/./${config.networking.hostName}";
            }
          ];
          source_directories = [
            "/persist/backup"
          ];

          encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."${config.networking.hostName}-borgbackup-passphrase".path}";
        };
    };
  };

  programs.ssh.knownHosts."domino.zdimension.fr".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAptqquuh/mkY/06LvfG4za2T3jAoenVR5vJnVOeVaeL";

  sops.secrets.guekka-backup-domino-ssh.sopsFile = ../secrets.yaml;

  systemd.timers.borgmatic = {
    enable = true;
    wantedBy = ["timers.target"];
    timerConfig = {
      Unit = "borgmatic.service";
      OnCalendar = "*-*-* 00:00:00";
      Persistent = true;
      WakeSystem = true;
    };
  };
}
