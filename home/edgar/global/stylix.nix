{
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./background.webp;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/selenized-light.yaml";

    cursor = {
      name = "Capitaine Cursors (Nord)";
      package = pkgs.capitaine-cursors-themed;
    };

    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      };
      sansSerif = {
        name = "Fira Sans";
        package = pkgs.fira;
      };
      sizes = {
        desktop = 12;
      };
    };
  };

  specialisation = {
    light.configuration = {
      stylix.polarity = "light";
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/selenized-light.yaml";
    };
    dark.configuration = {
      stylix.polarity = "dark";
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/selenized-dark.yaml";
    };
  };
}
