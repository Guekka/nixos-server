{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = "kondo";
    rev = "v${version}";
    hash = "sha256-m00zRNnryty96+pmZ2/ZFk61vy7b0yiWpomWzAHUAMk=";
  };

  cargoHash = "sha256-hG4bvcGYNwdNX9Wsdw30i3a3Ttxud+quNZpolgVKXQE=";

  meta = with lib; {
    description = "Cleans dependencies and build artifacts from your projects";
    homepage = "https://github.com/tbillington/kondo";
    changelog = "https://github.com/tbillington/kondo/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
