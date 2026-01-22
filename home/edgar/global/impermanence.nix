{lib, ...}: {
  # TODO move these to their own files

  home.persistence."/persist/backup" = {
    directories = [
      # Root dirs
      "Documents"
      "nixos"

      # Hidden root dirs (ever heard of XDG?)
      ".factorio"
      ".gnupg"
      # TODO: think about declaring known hosts instead
      ".ssh"

      # .config
      ".config/java"
      # TOOD: use a secret instead
      ".config/immich-go"
      ".config/keepassxc"
      ".config/qBittorrent"
      ".config/qmk"
    ];

    files = [
      "/.local/share/state/comma-choices"
    ];
  };

  home.persistence."/persist/nobackup" = {
    directories = [
      # Root dirs
      "Games"
      "code"
      "Downloads"

      # .cache
      ".cache/fontconfig"
      # contains last opened database. This is not cache, imo
      ".cache/keepassxc"
      ".cache/mesa_shader_cache"
      ".cache/mesa_shader_cache_db"
      ".cache/nix"
      ".cache/nix-index"
      ".cache/uv"

      # local/share
      ".local/share/plex"
      ".local/share/Steam"
      ".local/share/umu"
    ];
  };

  # See <https://github.com/nix-community/impermanence/issues/256>
  home.activation.fixPathForImpermanence = lib.hm.dag.entryBefore ["cleanEmptyLinkTargets"] ''
    PATH=$PATH:/run/wrappers/bin
  '';
}
