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
    owner = "lagmoellertim";
    repo = "unsilence";
    rev = version;
    hash = "sha256-M4Ek1JZwtr7vIg14aTa8h4otIZnPQfKNH4pZE4GpiBQ=";
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
