{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Edgar B";
    userEmail = "39066502+Guekka@users.noreply.github.com";

    aliases = {
      a = "add";
      b = "branch";

      # Show the current branch name (useful for shell prompts)
      brname = "!git branch | grep '^*' | awk '{ print $2 }'";

      cm = "commit -m";
      cma = "commit --amend --no-edit";

      # preserve original committer when rebasing. See <https://stackoverflow.com/a/76325489/10796945>
      rebase-preserving = ''
        !git -c rebase.instructionFormat='%s%nexec GIT_COMMITTER_DATE="%cD" GIT_COMMITTER_NAME="%cn" GIT_COMMITTER_EMAIL="%ce" GIT_AUTHOR_NAME="%cn" GIT_AUTHOR_EMAIL="%ce" git commit --amend --no-edit --reset-author --date="%cD"' rebase -i $@'';

      dfs = "diff --staged";

      makeIgnore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";

      # more compact log
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";

      p = "push";
      pf = "push  --force-with-lease";
      rb = "rebase";
      s = "status";
      st = "stash --include-untracked";
      sp = "stash pop";
      sw = "switch";
    };

    # some come from https://jvns.ca/blog/2024/02/16/popular-git-config-options/
    extraConfig = {
      diff = {
        algorithm = "histogram";
      };

      feature.manyFiles = true;

      fetch = {
        prune = true;
      };

      gpg = {
        format = "ssh";
      };

      help = {
        autocorrect = 3; # tenths of second before running
      };

      # see https://github.com/tummychow/git-absorb/issues/81
      index.skipHash = false;
      init.defaultBranch = "main";

      merge = {
        # https://ductile.systems/zdiff3/
        conflictStyle = "zdiff3";
      };

      pull = {
        rebase = true;
      };

      push = {
        autoSetupRemote = true;
        followTags = true;
      };

      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };

      rerere = {
        enabled = true;
        autoUpdate = true;
      };

      status = {
        showUntrackedFiles = "all";
      };

      url = {
        "https://github.com/".insteadOf = "gh:";
        "ssh://git@github.com".pushInsteadOf = "gh:";
        "https://gitlab.com/".insteadOf = "gl:";
        "ssh://git@gitlab.com".pushInsteadOf = "gl:";
      };
    };

    ignores = [".devenv" ".direnv" "result"];

    difftastic = {
      enable = true;
    };

    signing = {
      key = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuFlK3yFkBbd1o5UKajdGLUYnERF0YFpVOIUfYvlesy id_commit_signing";
      signByDefault = true;
    };
  };

  home.packages = [
    pkgs.git-absorb
  ];
}
