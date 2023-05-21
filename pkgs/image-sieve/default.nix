{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  libxkbcommon,
  ffmpeg,
  gtk3,
  stdenv,
  darwin,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "image-sieve";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "Futsch1";
    repo = "image-sieve";
    rev = "v${version}";
    hash = "sha256-dTtW7DTZoMVJI7MqwKROXNY6nair3TLfzfiANJ33+to=";
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
      fontconfig
      libxkbcommon
      ffmpeg
      gtk3
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreText
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Metal
      darwin.apple_sdk.frameworks.Security
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
    ];

  dontCargoCheck = true; # tests fail but app works

  meta = with lib; {
    description = "GUI based tool to sort and categorize images written in Rust";
    homepage = "https://github.com/Futsch1/image-sieve";
    changelog = "https://github.com/Futsch1/image-sieve/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
  };
}
