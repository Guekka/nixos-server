{pkgs, ...}: let
  pluginify = ide: pkgs.unstable.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  # jetbrains fails to build on 24.11
  home.packages = with pkgs.unstable.jetbrains;
  with pkgs; [
    (pluginify clion)
    (pluginify idea-ultimate)

    qtcreator
    staruml

    gcc # always have a C compiler ready
    python3 # and a Python interpreter
  ];
}
