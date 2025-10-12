{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:Guekka/helix/copilot"; ## fork with copilot support
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    wakatime-lsp = {
      url = "github:mrnossiom/wakatime-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdp-termfilepickers = {
      url = "github:Guekka/xdg-desktop-portal-termfilepickers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    yazi-compress = {
      url = "github:v3natio/compress.yazi";
      flake = false;
    };

    yazi-hexyl = {
      url = "github:Reledia/hexyl.yazi";
      flake = false;
    };

    yazi-augment-command = {
      url = "github:hankertrix/augment-command.yazi";
      flake = false;
    };

    yazi-what-size = {
      url = "github:pirafrank/what-size.yazi";
      flake = false;
    };

    yazi-flexoki-light = {
      url = "github:gosxrgxx/flexoki-light.yazi";
      flake = false;
    };

    yazi-flexoki-dark = {
      url = "github:gosxrgxx/flexoki-dark.yazi";
      flake = false;
    };

    # temporary for school project
    weather-risks = {
      url = "git+ssh://git@github.com/guekka/weather_risks.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # what will be produced (i.e. the build)
  outputs = {
    self,
    devenv,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});

    mkNixos = host: system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./hosts/${host}
        ];
      };

    mkHome = host: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit (self) inputs outputs;};
        modules = [
          ./home/edgar/${host}.nix
        ];
      };
  in {
    formatter = forEachPkgs (pkgs: pkgs.alejandra);

    packages = forEachPkgs (pkgs: import ./pkgs {inherit pkgs;});

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs;};

    devShells = forEachPkgs (pkgs: import ./shell.nix {inherit pkgs devenv inputs;});

    nixosConfigurations = {
      horus = mkNixos "horus" "aarch64-linux";
      hestia = mkNixos "hestia" "x86_64-linux";
      deimos = mkNixos "deimos" "x86_64-linux";
      pluto = mkNixos "pluto" "x86_64-linux";
    };

    homeConfigurations = {
      "edgar@horus" = mkHome "horus" "aarch64-linux";
      "edgar@hestia" = mkHome "hestia" "x86_64-linux";
      "edgar@deimos" = mkHome "deimos" "x86_64-linux";
      "edgar@pluto" = mkHome "pluto" "x86_64-linux";
    };
  };
}
