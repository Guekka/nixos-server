{
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
    # default example
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
}
