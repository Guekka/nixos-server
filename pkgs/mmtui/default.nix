{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "mmtui";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SL-RU";
    repo = "mmtui";
    rev = "v${version}";
    hash = "sha256-s+50kz6OODZ0xKz8oNF2YEzk+mLZ6gXXynl8g6Uwdo4=";
  };

  cargoHash = "sha256-PQaS5aXG6MCVOKfM6Y7dvAd8BA/8BJQvnXTgitMwtf8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "TUI disk mount manager for TUI file managers";
    homepage = "https://github.com/SL-RU/mmtui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "mmtui";
  };
}
