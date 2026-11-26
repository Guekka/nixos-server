{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  sopsAgeKeyFile = "/run/user/1000/sops-age/keys.txt";
  sopsAgeKeyDirectory = builtins.dirOf sopsAgeKeyFile;
  removeSopsAgeKeyFile = "${pkgs.coreutils}/bin/rm -f -- ${lib.escapeShellArg sopsAgeKeyFile}";
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
    inputs.sops-nix.homeManagerModules.sops
    ./global

    ./gui
  ];

  # Read private host settings from the ignored local .env during impure evaluation.
  home.username =
    requiredMorpheusValue "MORPHEUS_HOME_USERNAME" morpheusUsername;
  myHome.nonNixos.enable = true;
  myHome.impermanence.enable = false;

  sops = {
    defaultSopsFile = ./morpheus-secrets.yaml;
    age = {
      keyFile = sopsAgeKeyFile;
      sshKeyPaths = [];
    };
    secrets = {
      "ar-password" = {};
      "nix-access-tokens" = {};
    };
    templates."nix.conf".content = ''
      access-tokens = ${config.sops.placeholder."nix-access-tokens"}
    '';
  };

  systemd.user.services.sops-nix.Service = {
    ExecStartPre = lib.mkBefore [
      (pkgs.writeShellScript "sops-age-key-from-gnome-keyring" ''
        set -euo pipefail
        umask 077

        keyDirectory=${lib.escapeShellArg sopsAgeKeyDirectory}
        keyFile=${lib.escapeShellArg sopsAgeKeyFile}
        temporaryKeyFile="$keyFile.tmp"

        ${pkgs.coreutils}/bin/install -d -m 700 "$keyDirectory"
        ${pkgs.coreutils}/bin/chmod 700 "$keyDirectory"
        ${pkgs.coreutils}/bin/rm -f -- "$temporaryKeyFile"

        if ! ${pkgs.libsecret}/bin/secret-tool lookup application nixos-server purpose sops-age host morpheus > "$temporaryKeyFile" 2>/dev/null; then
          ${pkgs.coreutils}/bin/rm -f -- "$temporaryKeyFile"
          printf '%s\n' "Unable to retrieve the SOPS age identity from GNOME Keyring" >&2
          exit 1
        fi

        if [ ! -s "$temporaryKeyFile" ] || ! ${pkgs.age}/bin/age-keygen -y "$temporaryKeyFile" >/dev/null 2>&1; then
          ${pkgs.coreutils}/bin/rm -f -- "$temporaryKeyFile"
          printf '%s\n' "The GNOME Keyring SOPS age identity is missing or invalid" >&2
          exit 1
        fi

        ${pkgs.coreutils}/bin/chmod 600 "$temporaryKeyFile"
        ${pkgs.coreutils}/bin/mv -f -- "$temporaryKeyFile" "$keyFile"
      '')
    ];
    ExecStartPost = lib.mkAfter [removeSopsAgeKeyFile];
    ExecStopPost = lib.mkAfter [removeSopsAgeKeyFile];
  };

  nix.extraOptions = "!include ${config.sops.templates."nix.conf".path}";

  home.sessionVariablesExtra = ''
    if [ ! -r ${lib.escapeShellArg config.sops.secrets."ar-password".path} ]; then
      echo "Missing SOPS secret ar-password" >&2
      return 1
    fi

    export AR_PASSWORD="$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg config.sops.secrets."ar-password".path})"
  '';

  programs.git.settings = {
    user = lib.mkForce {
      name = requiredMorpheusValue "MORPHEUS_GIT_NAME" morpheusGitName;
      email = requiredMorpheusValue "MORPHEUS_GIT_EMAIL" morpheusGitEmail;
    };
    url = {
      "ssh://git@github.com".insteadOf = "https://github.com";
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
