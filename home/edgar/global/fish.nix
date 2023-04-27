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
          set files (fd . $argv -tf -x stat -c '%X %n')
          echo (files | sort -nr | head -n 1 | cut -f 2- -d ' ')
        '';
      };
    };

    shellAbbrs = {
      # safety measures
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      mkdir = "mkdir -p";
      which = "type -a"; # https://unix.stackexchange.com/a/85250
    };
  };
}
