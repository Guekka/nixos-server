{pkgs, ...}: {
  accounts.calendar = {
    basePath = ".local/share/calendars";

    accounts.nextcloud = {
      khal = {
        enable = true;
        type = "discover";
      };

      vdirsyncer = {
        enable = true;
        collections = ["from a" "from b"];
        metadata = ["color" "displayname"];
        conflictResolution = "remote wins";
      };

      local = {
        type = "filesystem";
        fileExt = ".ics";
      };

      remote = {
        type = "caldav";
        url = "https://domino.zdimension.fr/nextcloud/remote.php/dav";
        userName = "guekka";
        passwordCommand = ["${pkgs.bat}/bin/bat" "-p" "/home/edgar/secrets/nextcloud_pass"];
      };
    };
  };

  programs.vdirsyncer.enable = true;
  programs.khal = {
    enable = true;

    locale = {
      timeformat = "%H:%M";
      dateformat = "%d/%m/%Y";
      datetimeformat = "%d/%m/%Y %H:%M";
    };
  };
}
