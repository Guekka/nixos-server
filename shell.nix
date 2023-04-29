{
  devenv,
  pkgs,
  inputs,
}: {
  default = devenv.lib.mkShell {
    inherit pkgs inputs;
    modules = [
      {
        packages = with pkgs; [nix home-manager git sops];
        pre-commit.hooks = {
          shellcheck.enable = true; # shell static analysis
          alejandra.enable = true; # nix format
          deadnix.enable = true; # nix dead code remover
          # disabled for now, as it crashes for no reason
          statix.enable = false; # nix static analysis
        };
      }
    ];
  };
}
