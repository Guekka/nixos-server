{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "py-scene-detect";
  version = "0.6.3-release";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Breakthrough";
    repo = "PySceneDetect";
    rev = "v${version}";
    hash = "sha256-V9/+XZn1AB+RHgUwBZ1IN2vtIYQNaf8DN9b/PqSxNcQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    av
    click
    numpy
    opencv4
    platformdirs
    pytest
    tqdm
  ];

  pythonImportsCheck = ["scenedetect"];

  meta = with lib; {
    description = "Movie_camera: Python and OpenCV-based scene cut/transition detection program & library";
    homepage = "https://github.com/Breakthrough/PySceneDetect";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "py-scene-detect";
  };
}
