{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Edgar B";
    userEmail = "39066502+Guekka@users.noreply.github.com";

    extraConfig = {
      feature.manyFiles = true;
      # see https://github.com/tummychow/git-absorb/issues/81
      index.skipHash = false;

      init.defaultBranch = "main";

      # preserve original committer when rebasing. See <https://stackoverflow.com/a/76325489/10796945>
      fetch = {
        prune = true;
      };

      help = {
        autocorrect = 3; # tenths of second before running
      };

      pull = {
        rebase = true;
      };

      push = {
        autoSetupRemote = true;
        followTags = true;
      };

      rebase = {
        instructionFormat = "%s%nexec GIT_COMMITTER_DATE=\"%cI\" GIT_COMMITTER_NAME=\"%cN\" GIT_COMMITTER_EMAIL=\"%cE\" git commit --amend --no-edit --allow-empty --allow-empty-message%n";
      };

      push.autoSetupRemote = true;
    };
    ignores = [".direnv" "result"];

    difftastic = {
      enable = true;
    };
  };

  home.packages = [
    pkgs.git-absorb
  ];
}
