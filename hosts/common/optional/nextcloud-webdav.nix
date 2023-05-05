{
  config,
  pkgs,
  ...
}: {
  services.davfs2.enable = true;
  services.autofs = {
    enable = true;
    autoMaster = let
      mapConf = pkgs.writeText "autofs" ''
        nextcloud -fstype=davfs https\://nc.bizel.fr/remote.php/webdav/
      '';
    in ''
      /auto file:${mapConf}
    '';
  };

  sops.secrets.nextcloud_webdav = {
    path = "/etc/davfs2/secrets";
    sopsFile = ../secrets.yaml;
  };
}
