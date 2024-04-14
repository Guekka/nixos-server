{pkgs, ...}: let
  pluginify = ide: pkgs.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.jetbrains; [
    (pluginify clion)
    (pluginify idea-ultimate)

    pkgs.stable.qtcreator
    pkgs.ida-free
    pkgs.stable.staruml
  ];
}
