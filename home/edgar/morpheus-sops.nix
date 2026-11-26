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
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    defaultSopsFile = ./morpheus-secrets.yaml;
    age = {
      keyFile = sopsAgeKeyFile;
      sshKeyPaths = [];
    };
    secrets = {
      "ar-password" = {};
      "nix-access-tokens".sopsFile = ../../hosts/common/nix-secrets.yaml;
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
}
