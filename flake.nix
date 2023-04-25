{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
  };

  # what will be produced (i.e. the build)
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    overlays = let
      unstable-packages = final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      };
    in [
      unstable-packages
    ];
    nixosConfigurations = {
      horus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // self.outputs;
        modules = [
          ./hosts/horus
        ];
      };

      hestia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // self.outputs;
        modules = [
          ./hosts/hestia
        ];
      };
    };
  };
}
