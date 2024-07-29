{pkgs, ...}: let
  pluginify = ide: pkgs.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.jetbrains; [
    (pluginify clion)
    (pluginify idea-ultimate)

    pkgs.stable.qtcreator
    pkgs.stable.staruml

    pkgs.stable.gcc # always have a C compiler ready
    pkgs.stable.python3 # and a Python interpreter
  ];
}
