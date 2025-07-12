{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kobo-readstat";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "timchurchard";
    repo = "kobo-readstat";
    rev = "v${version}";
    hash = "sha256-pHMK65wnTAG5IxFkMbt/ete6izp9zcD8P/T9ZCkrs2U=";
  };

  vendorHash = "sha256-eYxfjdkhwJjuN2EZeOopTE+Kp50UurTMRRijBGW6lCQ=";

  doCheck = false;

  ldflags = ["-s" "-w"];

  meta = {
    description = "";
    homepage = "https://github.com/timchurchard/kobo-readstat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "kobo-readstat";
  };
}
