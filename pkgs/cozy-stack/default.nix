{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cozy-stack";
  version = "1.6.14";

  src = fetchFromGitHub {
    owner = "cozy";
    repo = "cozy-stack";
    rev = version;
    hash = "sha256-iVLil4nk1GEmqRmydLG/Tc0MmXmPNsnGKf/BjrUKb50=";
  };

  vendorHash = "sha256-lIYe7SMZFjAYAez34i+4nA2SjdAr3gHYmYaCna0eGZI=";

  doCheck = false; # Some tests require couchdb

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Simple, Versatile, Yours";
    homepage = "https://github.com/cozy/cozy-stack";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "cozy-stack";
  };
}
