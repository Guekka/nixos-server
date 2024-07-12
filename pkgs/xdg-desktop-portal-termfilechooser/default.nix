{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
  inih,
  libdrm,
  mesa,
  scdoc,
  systemd,
  wayland,
}:
stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "yazi-common";

  src = fetchFromGitHub {
    owner = "exquo";
    repo = "xdg-desktop-portal-termfilechooser";
    rev = version;
    hash = "sha256-GrCBBFQoGVTt9ayWSXrNhW6bzMkZZV34s/o9VDWvKoU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    makeWrapper
  ];

  buildInputs = [
    inih
    libdrm
    mesa
    scdoc
    systemd
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    (lib.mesonOption "sd-bus-provider" "libsystemd")
    (lib.mesonOption "sysconfdir" "/etc")
  ];

  patches = [
    (fetchpatch {
      name = "install_all_scripts.patch";
      url = "https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser/commit/291adb39d727120183046a664149827470c4faed.patch";
      hash = "sha256-WvwF32VZmd4loi8Rnkp6xlHyPaEZ9QAZikvwI9cdFjs=";
    })
  ];

  meta = with lib; {
    description = "Xdg-desktop-portal backend for choosing files with your favorite file chooser";
    homepage = "https://github.com/exquo/xdg-desktop-portal-termfilechooser/tree/yazi-common";
    license = licenses.mit;
    maintainers = with maintainers; [guekka];
    mainProgram = "xdg-desktop-portal-termfilechooser";
    platforms = platforms.all;
  };
}
