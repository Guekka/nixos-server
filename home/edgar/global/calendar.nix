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
        url = "https://nc.bizel.fr/remote.php/dav";
        userName = "edgar";
        passwordCommand = ["${pkgs.bat}/bin/bat" "-p" "/home/edgar/secrets/nextcloud_pass"];
      };

      thunderbird = {
        enable = true;
        # Thunderbird needs the concrete collection URL; vdirsyncer discovers from the DAV root.
        settings = id: {
          "calendar.registry.calendar_${id}.uri" = "https://nc.bizel.fr/remote.php/dav/calendars/edgar/personal/";
        };
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

  myHome.impermanence.passthrough."/persist/nobackup".directories = [
    ".local/share/khal"
  ];
}
