{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  # what will be produced (i.e. the build)
  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations = {
      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/horus
        ];
      };
    };
  };
}
