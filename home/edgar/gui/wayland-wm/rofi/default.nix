{
  config,
  lib,
  pkgs,
  ...
}: let
  waylandCommands = import ../commands.nix {inherit config lib pkgs;};

  cliphist-rofi-img = pkgs.writeShellScript "cliphist-rofi-img" ''
    tmp_dir="/tmp/cliphist"
    rm -rf "$tmp_dir"

    if [[ -n "$1" ]]; then
        cliphist decode <<<"$1" | wl-copy
        exit
    fi

    mkdir -p "$tmp_dir"

    read -r -d \'\' prog <<EOF
    /^[0-9]+\s<meta http-equiv=/ { next }
    match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
        system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
        print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
        next
    }
    1
    EOF
    cliphist list | gawk "$prog"
  '';
in {
  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-calc
    ];
    inherit (waylandCommands) terminal;
    extraConfig = let
      baseModes = "drun,filebrowser,ssh,clipboard:${cliphist-rofi-img}";
    in {
      modi = "${baseModes},calc,combi";
      combi-modi = "${baseModes}";
      show-icons = true;
      display-drun = "🔍 Apps";
      display-run = "🔧 Run";
      display-filebrowser = "📂 Files";
      display-ssh = "🔑 SSH";
      display-ollama = "🧠 Ollama";
      display-vscode-recent = "📂 VSCode Recent";
      display-clipboard = "Clipboard";
      dpi = 1;
    };
  };
}
