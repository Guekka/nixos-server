{pkgs, ...}: let
  pluginify = ide: pkgs.unstable.jetbrains.plugins.addPlugins ide ["github-copilot"];
in {
  home.packages = with pkgs.unstable.jetbrains; [
    (pluginify clion)
    (pluginify idea-ultimate)
  ];
}
