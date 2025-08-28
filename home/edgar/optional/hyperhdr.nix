{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services.hyperhdr = let
    hyperhdr-wrapper = pkgs.hyperhdr.overrideAttrs (_old: {
      postFixup = ''
        wrapProgram $out/bin/hyperhdr --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.libGL]}
      '';
    });
  in {
    Unit = {
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      Type = "simple";
      ExecStart = ''
        ${lib.getExe' hyperhdr-wrapper "hyperhdr"} --pipewire
      '';
      Restart = "on-failure";
    };
  };

  home.persistence."/persist/backup/home/edgar".directories = [
    ".hyperhdr"
  ];
}
