{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./heroic.nix
  ];

  home.packages = with pkgs; [
    inputs.umu-launcher.packages.${pkgs.system}.umu
    lutris
  ];
}
