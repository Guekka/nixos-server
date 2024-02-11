{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "awatcher";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = pname;
    rev = "v0.2.1";
    sha256 = "MP66FAvNstiHDIGS/SolctY1pWlysY3p0PYWPZSGkQI=";
  };

  cargoLock = {
    lockFile = ./cargo.lock;
    outputHashes = {
      "aw-client-rust-0.1.0" = "fCjVfmjrwMSa8MFgnC8n5jPzdaqSmNNdMRaYHNbs8Bo=";
    };
  };

  buildInputs = [openssl];
  nativeBuildInputs = [pkg-config];
}
