{
  programs = {
    fish.loginShellInit = ''
      if test (tty) = "/dev/tty1"
        exec niri-session &> /dev/null
      end
    '';
    zsh.loginExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec niri-session &> /dev/null
      fi
    '';
    zsh.profileExtra = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec niri-session &> /dev/null
      fi
    '';
  };
}
