{pkgs, ...}: let
  pluginify = ide: pkgs.stable.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.stable.jetbrains; [
    (pluginify clion)
    (pluginify idea-ultimate)

    pkgs.stable.qtcreator
    pkgs.ida-free
    pkgs.stable.staruml
  ];
}
