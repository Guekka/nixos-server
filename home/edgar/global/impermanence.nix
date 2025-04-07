{
  inputs,
  lib,
  ...
}: let
  withSymlink = dir: {
    directory = dir;
    method = "symlink";
  };
in {
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  # TODO move these to their own files

  home.persistence."/persist/backup/home/edgar" = {
    directories = [
      # Root dirs
      "Documents"
      "nixos"

      # Hidden root dirs (ever heard of XDG?)
      (withSymlink ".factorio")
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

    allowOther = true;
  };

  home.persistence."/persist/nobackup/home/edgar" = {
    directories = [
      # Root dirs
      (withSymlink "Games")
      (withSymlink "code")
      "Downloads"

      # .cache
      ".cache/fontconfig"
      # contains last opened database. This is not cache, imo
      ".cache/keepassxc"
      (withSymlink ".cache/mesa_shader_cache")
      (withSymlink ".cache/mesa_shader_cache_db")
      ".cache/nix"
      ".cache/nix-index"
      ".cache/uv"

      # local/share
      ".local/share/plex"
      (withSymlink ".local/share/Steam")
      (withSymlink ".local/share/umu")
    ];
    allowOther = true;
  };

  # See <https://github.com/nix-community/impermanence/issues/256>
  home.activation.fixPathForImpermanence = lib.hm.dag.entryBefore ["cleanEmptyLinkTargets"] ''
    PATH=$PATH:/run/wrappers/bin
  '';
}
