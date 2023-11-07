{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Edgar B";
    userEmail = "39066502+Guekka@users.noreply.github.com";

    aliases = {
      a = "add";
      br = "branch";

      # Show the current branch name (useful for shell prompts)
      brname = "!git branch | grep '^*' | awk '{ print $2 }'";

      cm = "commit -m";
      cma = "commit --amend --no-edit";

      dfs = "diff --staged";

      # more compact log
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";

      pf = "push  --force-with-lease";
      s = "status";
      st = "stash --include-untracked";
      sw = "switch";
    };

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

      help = {
        autocorrect = true;
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

        autoStash = true;
        autoSquash = true;
      };

      rerere = {
        enabled = true;
        autoUpdate = true;
      };

      status = {
        showUntrackedFiles = "all";
      };
    };

    ignores = [".devenv" ".direnv" "result"];

    difftastic = {
      enable = true;
    };
  };

  home.packages = [
    pkgs.git-absorb
  ];
}
