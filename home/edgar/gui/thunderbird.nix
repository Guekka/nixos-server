{pkgs, ...}: let
  tutaMailAddon = pkgs.stdenvNoCC.mkDerivation {
    pname = "thunderbird-tuta-mail";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://addons.thunderbird.net/thunderbird/downloads/file/1044559/tuta_mail-1.0.0-tb.xpi";
      hash = "sha256-2ZHCaG5oGnAu4qcIEN1805onwkyNXZ/gjEPpWILuSgk=";
    };

    dontUnpack = true;

    installPhase = ''
      install -Dm444 "$src" "$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/@tutamail.thunderbird.xpi"
    '';
  };
in {
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions = [tutaMailAddon];
      settings."extensions.autoDisableScopes" = 0;
    };
  };

  myHome.impermanence.passthrough."/persist/backup".directories = [
    ".thunderbird"
  ];
}
