{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  stdenv,
  wayland,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "lan-mouse";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "ferdinandschober";
    repo = "lan-mouse";
    rev = "v${version}";
    hash = "sha256-prQCzj3/eX0409eEOmM6h4ZbcL/yBrs404EhGMKeXhs=";
  };

  cargoHash = "sha256-NqL2MGaxEekEWCtxg0oYxB9FJIBlEX74pErbLfngqDk=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      cairo
      gdk-pixbuf
      glib
      gtk4
      libadwaita
      pango
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
      xorg.libX11
      xorg.libXtst
    ];

  meta = with lib; {
    description = "Software KVM Switch / mouse & keyboard sharing software for Local Area Networks";
    homepage = "https://github.com/ferdinandschober/lan-mouse";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "lan-mouse";
  };
}
