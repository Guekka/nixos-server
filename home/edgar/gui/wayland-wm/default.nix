{
  imports = [
    ./albert
    ./cliphist.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./rofi
    ./swaync.nix
    ./swww.nix
    ./termfilepickers.nix
    ./waybar.nix
  ];
  wayland.windowManager.hyprland.configType = "hyprlang";
}
