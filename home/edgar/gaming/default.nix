{pkgs, ...}: {
  imports = [
    ./heroic.nix
  ];

  home = {
    packages = with pkgs; [
      joystickwake
      lutris
    ];

    persistence = {
      "/persist/backup".directories = [
        ".config/lutris"
        ".local/share/Terraria"
      ];

      "/persist/nobackup".directories = [
        ".local/share/lutris"
        ".cache/lutris"
      ];
    };
  };
}
