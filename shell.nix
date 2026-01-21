{
  devenv,
  pkgs,
  inputs,
  ...
}: {
  default = devenv.lib.mkShell {
    inherit pkgs inputs;
    modules = [
      {
        packages = with pkgs; [
          home-manager
          git
          sops
          statix
          helix
        ];
        git-hooks.hooks = {
          shellcheck.enable = true; # shell static analysis
          alejandra.enable = true; # nix format
          deadnix.enable = true; # nix dead code remover
          statix.enable = true; # nix static analysis
        };
      }
    ];
  };
}
