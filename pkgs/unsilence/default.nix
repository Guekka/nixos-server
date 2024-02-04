{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "unsilence";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimon58";
    repo = "unsilence";
    rev = "5346296c2323a0eebbd8184eadb8b9324ae75e08";
    hash = "sha256-A/OTcwk735vZI9BCUBcGf/FicMxkR545DsmoOBruHH0=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    rich
  ];

  pythonImportsCheck = ["unsilence"];

  meta = with lib; {
    description = "Console Interface and Library to remove silent parts of a media file";
    homepage = "https://github.com/lagmoellertim/unsilence";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "unsilence";
  };
}
