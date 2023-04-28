{inputs, lib, ...}: let
  flakes = lib.filterAttrs (name: value: value ? outputs) inputs;
  nixRegistry = lib.mapAttrs (name: v: {flake = v;}) flakes;
in {
  nix = {
    settings = {
      trusted-users = ["root" "@wheel"];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # Delete older generations too
      options = "--delete-older-than 7d";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = nixRegistry;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
  };
}
