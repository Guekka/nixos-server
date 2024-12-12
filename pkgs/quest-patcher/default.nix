{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "quest-patcher";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "Lauriethefish";
    repo = "QuestPatcher";
    rev = version;
    hash = "sha256-ed/4AH+kNmDbDd5zzaNA6tIwHdliv/isJaNGwuOsMsk=";
  };

  meta = with lib; {
    description = "Generic il2cpp modding tool for Oculus Quest (1/2/3) apps";
    homepage = "https://github.com/Lauriethefish/QuestPatcher";
    license = licenses.zlib;
    maintainers = with maintainers; [];
    mainProgram = "quest-patcher";
    platforms = platforms.all;
  };
}
