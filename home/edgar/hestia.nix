{nix-colors, ...}: {
  imports = [
    ./global
    ./optional/gnome.nix
    ./optional/activitywatch.nix
    ./optional/heroic.nix
    ./optional/jetbrains.nix
    ./optional/ledger.nix
    nix-colors.homeManagerModules.default
  ];
  colorScheme = nix-colors.colorSchemes.dracula;
}
