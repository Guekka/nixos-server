{inputs, ...}: {
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  # TODO: move these to their own files

  home.persistence."/persist/home/edgar" = {
    directories = let
      withSymlink = dir: {
        directory = dir;
        method = "symlink";
      };

      # TODO: write this function to split electron app into correct XDG dirs
      electronApp =
        /*
         let
          electronCacheDirs = ["Cache" "CachedData" "CachedExtensions" "Code Cache" "DawnCache" "GPUCache"];
          electronStateDirs = ["Cookies" "IndexedDB" "LocalStorage" "Session Storage"];
        in
        */
        app: [
          (withSymlink ".config/${app}")
        ];
    in
      [
        # Root dirs
        (withSymlink "code")
        "Documents"
        "Downloads"
        (withSymlink "Games")
        "nixos"
        "Nextcloud"

        # Hidden root dirs (ever heard of XDG?)
        (withSymlink ".factorio")
        ".gnupg"
        ".mozilla"
        # TODO: think about declaring known hosts instead
        ".ssh"

        # .cache
        ".cache/bat"
        ".cache/fontconfig"
        # contains last opened database. This is not cache, imo
        ".cache/keepassxc"
        ".cache/kitty"
        ".cache/mesa_shader_cache"
        ".cache/mesa_shader_cache_db"
        ".cache/mozilla"
        ".cache/nix"
        ".cache/nix-index"
        ".cache/uv"

        # .config
        ".config/calibre"
        ".config/fish"
        ".config/java"
        # TOOD: use a secret instead
        ".config/immich-go"
        ".config/keepassxc"
        ".config/lutris"
        ".config/Nextcloud"
        ".config/qBittorrent"

        # .local/share
        ".local/share/activitywatch"
        ".local/share/atuin"
        ".local/share/direnv"
        ".local/share/fish"
        ".local/share/khal"
        ".local/share/lutris"
        ".local/share/plex"
        ".config/qBittorrent"
        (withSymlink ".local/share/Steam")
        (withSymlink ".local/share/umu")
        ".local/share/zoxide"

        # .local/state
        ".local/state/lazygit"
      ]
      ++ (electronApp "Beeper")
      ++ (electronApp "Ledger Live");

    files = [
      "/.local/share/state/comma-choices"
    ];

    allowOther = true;
  };
}
