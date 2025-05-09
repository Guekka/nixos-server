{
  inputs,
  outputs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };

  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
}
