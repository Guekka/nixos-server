{pkgs, ...}: {
  home.packages = [pkgs.rclone];

  home.sessionVariables = {
    RCLONE_PROGRESS = "1";
  };

  xdg.configFile."rclone/rclone.conf".text = ''
    [deimos]
    type = sftp
    host = deimos
    shell_type = unix
    md5sum_command = md5sum
    sha1sum_command = sha1sum

    [hestia]
    type = sftp
    host = hestia
    shell_type = unix
    md5sum_command = md5sum
    sha1sum_command = sha1sum

    [horus]
    type = sftp
    host = horus
    shell_type = unix
    md5sum_command = md5sum
    sha1sum_command = sha1sum
  '';
}
