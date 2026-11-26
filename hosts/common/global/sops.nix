{
  inputs,
  config,
  ...
}: let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.sshKeyPaths = map getKeyPath keys;

    secrets."nix-access-tokens".sopsFile = ../nix-secrets.yaml;

    templates."nix.conf" = {
      content = ''
        access-tokens = ${config.sops.placeholder."nix-access-tokens"}
      '';
      owner = "edgar";
      mode = "0400";
    };
  };
}
