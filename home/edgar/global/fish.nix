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

  home.persistence = {
    "/persist/backup/home/edgar".directories = [
      ".config/fish"
    ];

    "/persist/nobackup/home/edgar".directories = [
      ".local/share/fish"
    ];
  };
}
