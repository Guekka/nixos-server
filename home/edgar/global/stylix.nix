{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  stylix = {
    enable = true;
    autoEnable = true;
    image = config.wallpaper;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/selenized-light.yaml";
    polarity = lib.mkDefault "light";

    cursor = {
      name = "Capitaine Cursors (Nord)";
      package = pkgs.capitaine-cursors-themed;
      size = 24;
    };

    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerd-fonts.fira-code;
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
      # nh integration
      xdg.dataFile."home-manager/specialisation".text = "light";

      stylix.polarity = "light";
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/selenized-light.yaml";
    };
    dark.configuration = {
      xdg.dataFile."home-manager/specialisation".text = "dark";

      stylix.polarity = "dark";
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/selenized-dark.yaml";
    };
  };
}
