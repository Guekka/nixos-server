{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
}:
stdenv.mkDerivation rec {
  pname = "clight-gui";
  version = "unstable-2023-02-21";

  src = fetchFromGitHub {
    owner = "nullobsi";
    repo = "clight-gui";
    rev = "29e7216bfcc68135350a695ce446134bcb0463a6";
    hash = "sha256-U4vaMwnVDZnYLc+K3/yD81Q1vyBL8uSrrhOHbjbox5U=";
  };

  buildInputs = [
    qt5.qtbase
    qt5.qtcharts
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    qt5.qttools
  ];

  cmakeFlags = [
    "-S ../src"
    "-Wno-dev"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGENERATE_TRANSLATIONS=ON"
  ];

  postInstall = let
    desktop-entry = ''
      [Desktop Entry]
      Type=Application
      Icon=clight
      Name=Clight GUI
      Exec=$out/bin/clight-gui
      Terminal=false
      Hidden=false
      Categories=Utility
      Comment=Qt GUI for Clight
    '';
  in ''
    mkdir -p "$out/share/applications"
    cat >>"$out/share/applications/${pname}.desktop" <<_EOF
      ${desktop-entry}
    _EOF
  '';

  meta = with lib; {
    description = "Qt GUI for clight";
    homepage = "git@github.com:nullobsi/clight-gui.git";
    license = licenses.gpl3Only;
    maintainers = [];
  };
}
