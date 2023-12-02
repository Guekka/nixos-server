{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  ffmpeg,
  gtk3,
  libxkbcommon,
  seatd,
  udev,
  stdenv,
  darwin,
  wayland,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "image-sieve";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "Futsch1";
    repo = "image-sieve";
    rev = "v${version}";
    hash = "sha256-CeT4QbF+UIe3bLXkFXJzX24WC6cA2mBpZLZolsZeA8Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      makeWrapper
      libxkbcommon
      ffmpeg.dev
      gtk3
      seatd
      udev
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreText
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Metal
      darwin.apple_sdk.frameworks.Security
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
    ];

  postInstall = let
    libPath = lib.makeLibraryPath [
      libxkbcommon
      wayland
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ];
  in ''
    wrapProgram "$out/bin/image_sieve" --set LD_LIBRARY_PATH "${libPath}"
  '';

  dontCargoCheck = true; # tests fail but app works

  meta = with lib; {
    description = "GUI based tool to sort and categorize images written in Rust";
    homepage = "https://github.com/Futsch1/image-sieve";
    changelog = "https://github.com/Futsch1/image-sieve/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "image-sieve";
  };
}
