{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.rclone];

  home.sessionVariables = {
    RCLONE_PROGRESS = "1";
  };

  xdg.configFile."rclone/rclone.conf".text = let
    mkSshHost = host: ''
      [${host}]
      type = sftp
      host = ${host}
      shell_type = unix
      md5sum_command = md5sum
      sha1sum_command = sha1sum
    '';
  in
    lib.concatStringsSep "\n" (map mkSshHost [
      "horus"
      "deimos"
      "pluto"
      "hestia"
    ]);
}
