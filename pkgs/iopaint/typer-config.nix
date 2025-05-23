{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  typer,
  python-dotenv,
  pyyaml,
  toml,
}:
buildPythonPackage rec {
  pname = "typer-config";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "typer_config";
    inherit version;
    hash = "sha256-SMZZVKFRkq1kOawWxLyR5LQG/bBV+e5m5LRnzRTOomU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    typer
  ];

  passthru.optional-dependencies = {
    all = [
      python-dotenv
      pyyaml
      toml
    ];
    python-dotenv = [
      python-dotenv
    ];
    toml = [
      toml
    ];
    yaml = [
      pyyaml
    ];
  };

  pythonImportsCheck = ["typer_config"];

  meta = with lib; {
    description = "Utilities for working with configuration files in typer CLIs";
    homepage = "https://pypi.org/project/typer-config";
    license = licenses.mit;
    maintainers = with maintainers; [chayleaf];
  };
}
