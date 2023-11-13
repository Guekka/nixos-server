{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "goatcounter";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "goatcounter";
    rev = "v${version}";
    hash = "sha256-L4310L+L2Qn8NkRMqze7KNwZ18LXz8PAoXCCpYa5J4I=";
  };

  subPackages = ["cmd/goatcounter"];

  ldflags = ["-X=main.Version=${version}"];

  doCheck = false;
  vendorHash = "sha256-nKfqZ5hGGVLBY/hnJJPCrS/9MlGoR2MWFUWDnpwWgyM=";

  meta = with lib; {
    description = "Easy web analytics. No tracking of personal data";
    homepage = "https://github.com/arp242/goatcounter";
    changelog = "https://github.com/arp242/goatcounter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "goatcounter";
  };
}
