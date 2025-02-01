{pkgs, ...}: let
  pluginify = ide: pkgs.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.jetbrains;
  with pkgs; [
    (pluginify clion)
    (pluginify idea-ultimate)

    qtcreator
    staruml

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
}
