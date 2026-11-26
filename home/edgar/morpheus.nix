{
  lib,
  pkgs,
  ...
}: let
  morpheusUsername = builtins.getEnv "MORPHEUS_HOME_USERNAME";
  morpheusGitName = builtins.getEnv "MORPHEUS_GIT_NAME";
  morpheusGitEmail = builtins.getEnv "MORPHEUS_GIT_EMAIL";
  morpheusAcmdToolingDir = builtins.getEnv "MORPHEUS_ACMD_TOOLING_DIR";
  requiredMorpheusValue = name: value:
    if value == ""
    then throw "Set ${name} in the local .env and evaluate with --impure"
    else value;
in {
  imports = [
    ./morpheus-sops.nix
    ./global

    ./gui
  ];

  # Read private host settings from the ignored local .env during impure evaluation.
  home.username =
    requiredMorpheusValue "MORPHEUS_HOME_USERNAME" morpheusUsername;
  myHome.nonNixos.enable = true;
  myHome.impermanence.enable = false;

  programs.firefox = {
    configPath = ".config/mozilla/firefox";
    profiles = {
      default = {
        id = 1;
        path = "pw0bxc7h.default";
        isDefault = true;
      };
      default-release = {
        id = 0;
        path = "3olwdi2k.default-release";
        isDefault = false;
      };
    };
  };
  stylix.targets.firefox.profileNames = [
    "default"
    "default-release"
  ];
  myHome.impermanence.passthrough."/persist/backup".directories = [
    ".config/mozilla/firefox"
  ];

  programs.git.settings = {
    user = lib.mkForce {
      name = requiredMorpheusValue "MORPHEUS_GIT_NAME" morpheusGitName;
      email = requiredMorpheusValue "MORPHEUS_GIT_EMAIL" morpheusGitEmail;
    };
  };

  wallpaper = ./gui/background21.png;

  home.packages = [
    pkgs.maven
    pkgs.unstable.bruno
    pkgs.unstable.bruno-cli
    pkgs.remmina
    pkgs.git-spice
    pkgs.unstable.winboat
    pkgs.wineWow64Packages.waylandFull
    pkgs.winetricks
    pkgs.socat
    pkgs.gh
  ];

  services.ssh-agent.enable = true;
  systemd.user.services.ssh-agent.Unit.X-SwitchMethod = "keep-old";

  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1600;
      refreshRate = 120.0;
      scale = 1.25;
      x = 0;
      workspace = "1";
      primary = true;
      vrr = true;
    }
  ];

  home.sessionVariables = {
    ACMD_TOOLING_DIR =
      requiredMorpheusValue "MORPHEUS_ACMD_TOOLING_DIR" morpheusAcmdToolingDir;
    JAVA_HOME = "${pkgs.jdk25_headless}";
    AR_USER = requiredMorpheusValue "MORPHEUS_HOME_USERNAME" morpheusUsername;
  };
}
