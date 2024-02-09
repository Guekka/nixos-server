{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        randr
        rink
        shell
        symbols
        translate
        websearch
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    # styles from <https://github.com/linuxmobile/kaku/blob/22215104f37386b0b94b69056a29d117cad218b5/home/software/anyrun/style-dark.css>
    extraCss = builtins.readFile (./. + "/style-${config.colorscheme.variant}.css");

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: false,
        max_entries: 5,
        terminal: Some("kitty"),
      )
    '';
  };
}
