{
  pkgs,
  lib,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    package = pkgs.unstable.jujutsu; # moves fast
    settings = {
      user = {
        name = "Edgar B";
        mail = "39066502+Guekka@users.noreply.github.com";
      };

      ui = {
        diff.tool = ["difft" "--color=always" "$left" "$right"];
        # Uses Git's "diff3" conflict markers to support tools that depend on it
        conflict-marker-style = "git";
      };

      merge-tools.mergiraf = {
        program = lib.getExe pkgs.mergiraf;
        merge-args = ["merge" "$base" "$left" "$right" "-o" "$output" "-l" "$marker_length" "--fast"];
        merge-conflict-exit-codes = [1];
      };

      revset-aliases = {
        # prevent rewriting commits authored by other users
        "immutable_heads()" = "builtin_immutable_heads() | (trunk().. & ~mine())";
      };
    };
  };
}
