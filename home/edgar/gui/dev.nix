{pkgs, ...}: let
  pluginify = ide: pkgs.prev-stable.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.prev-stable.jetbrains;
  with pkgs; [
    (pluginify clion)
    (pluginify idea-ultimate)
    (pluginify rust-rover)

    qtcreator

    gcc # always have a C compiler ready
    python3 # and a Python interpreter
  ];

  home.persistence."/persist/nobackup/home/edgar" = {
    directories = [
      ".cache/JetBrains"
      ".config/JetBrains"
      ".local/share/JetBrains"

      ".config/github-copilot"
    ];
  };

  home.file."idea.properties".text = ''
    # See <https://github.com/NixOS/nixpkgs/pull/318358>
    idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier
  '';
}
