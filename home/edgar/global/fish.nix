{
  programs.fish = {
    enable = true;
    functions = {
      # finds latest file in a directory, mostly for the last download
      latest = {
        body = ''
          # no argument
          if test -z "$argv[1]"
            set argv[1] dl
          end
          if [ "$argv[1]" = "dl" ]
            set argv[1] "$HOME/Downloads"
          end
          echo (fd . $argv -tf -x stat -c '%X %n' | sort -nr | head -n 1 | cut -f 2- -d ' ')
        '';
      };

      # run command in each directory passed as argument in parallel
      run-all = {
        body = ''
          # Usage: run-all <dir1> <dir2> ... -- <command>
          # Find the separator '--'
          set sep_idx 0
          for i in (seq (count $argv))
            if test "$argv[$i]" = "--"
              set sep_idx $i
              break
            end
          end

          if test $sep_idx -eq 0
            echo "Usage: run-all <dir1> <dir2> ... -- <command>" >&2
            return 1
          end

          set dirs $argv[1..(math $sep_idx - 1)]
          set cmd $argv[(math $sep_idx + 1)..-1]

          if test (count $dirs) -eq 0; or test (count $cmd) -eq 0
            echo "Usage: run-all <dir1> <dir2> ... -- <command>" >&2
            return 1
          end

          set pids
          for dir in $dirs
            fish -c "cd $(string escape $dir) && $cmd" &
            set -a pids $last_pid
          end

          set failed 0
          for pid in $pids
            if not wait $pid
              set failed (math $failed + 1)
            end
          end

          return $failed
        '';
      };
    };

    shellAbbrs = {
      # safety measures
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      mkdir = "mkdir -p";
    };

    shellAliases = {
      which = "readlink -f (type -p $argv)";
    };

    interactiveShellInit = ''
      # Open command buffer in vim when alt+e is pressed
      bind \ee edit_command_buffer

      # Use vim bindings and cursors
      fish_vi_key_bindings
      set fish_cursor_default     block      blink
      set fish_cursor_insert      line       blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual      block
    '';
  };

  myHome.impermanence.passthrough = {
    "/persist/backup".directories = [
      ".config/fish"
    ];

    "/persist/nobackup".directories = [
      ".local/share/fish"
    ];
  };
}
