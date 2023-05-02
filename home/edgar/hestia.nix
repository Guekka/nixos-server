{inputs, ...}: {
  imports = [
    ./global
    ./optional/gnome.nix
    ./optional/activitywatch.nix
    ./optional/heroic.nix
    ./optional/jetbrains.nix
    ./optional/ledger.nix
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.dracula;
}
