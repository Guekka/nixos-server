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
  darwin,
  wayland,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "lan-mouse";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ferdinandschober";
    repo = "lan-mouse";
    rev = "v${version}";
    hash = "sha256-98n0Y9oL/ll90NKHJC/25wkav9K+eVqrO7PlrJMoGmY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "reis-0.1.0" = "sha256-sRZqm6QdmgqfkTjEENV8erQd+0RL5z1+qjdmY18W3bA=";
    };
  };

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
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreGraphics
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
      xorg.libX11
      xorg.libXtst
    ];

  meta = with lib; {
    description = "Mouse & keyboard sharing via LAN";
    homepage = "https://github.com/ferdinandschober/lan-mouse";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "lan-mouse";
  };
}
