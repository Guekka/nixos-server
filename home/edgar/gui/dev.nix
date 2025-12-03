{pkgs, ...}: let
  pluginify = ide: pkgs.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.jetbrains;
  with pkgs; [
    (pluginify clion)
    (pluginify idea-ultimate)
    (pluginify rust-rover)

    qtcreator

    gcc # always have a C compiler ready
    # and a Python interpreter with some default packages
    (python3.withPackages (ps: [ps.numpy]))
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
