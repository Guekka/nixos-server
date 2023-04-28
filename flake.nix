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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
  };

  # what will be produced (i.e. the build)
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

    mkNixos = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./hosts/${host}
        ];
      };

    mkHome = host:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./home/edgar/${host}.nix
        ];
      };
  in {
    formatter = forEachPkgs (pkgs: pkgs.alejandra);

    packages = forEachPkgs (pkgs: import ./pkgs {inherit pkgs;});

    overlays = import ./overlays {inherit (inputs) nixpkgs-unstable packages;};

    nixosConfigurations = {
      horus = mkNixos "horus";
      hestia = mkNixos "hestia";
      deimos = mkNixos "deimos";
    };

    homeConfigurations = {
      "edgar@horus" = mkHome "horus";
      "edgar@hestia" = mkHome "hestia";
      "edgar@deimos" = mkHome "deimos";
    };
  };
}
