{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}: let
  asyncer = python3.pkgs.buildPythonPackage rec {
    pname = "asyncer";
    version = "0.0.8"; # Replace with the correct version
    pyproject = true;
    build-system = [python3Packages.pdm-backend];
    src = fetchFromGitHub {
      owner = "fastapi";
      repo = pname;
      rev = version;
      hash = "sha256-SbByOiTYzp+G+SvsDqXOQBAG6nigtBXiQmfGgfKRqvM=";
    };

    dependencies = [
      python3Packages.anyio
      python3Packages.typing-extensions
    ];
  };
in
  python3.pkgs.buildPythonApplication rec {
    pname = "rembg";
    version = "2.0.61";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "danielgatis";
      repo = "rembg";
      rev = "v${version}";
      hash = "sha256-VKPiQKV74D1OtMXsGJGfv91ffWyPzsrhM7wveQs3yrQ=";
    };

    dependencies = [
      asyncer
      python3Packages.aiohttp
      python3Packages.click
      python3Packages.fastapi
      python3Packages.filetype
      python3Packages.gradio
      python3Packages.jsonschema
      python3Packages.numpy
      python3Packages.onnxruntime
      python3Packages.opencv4
      python3Packages.pillow
      python3Packages.pooch
      python3Packages.pymatting
      python3Packages.python-multipart
      python3Packages.scikit-image
      python3Packages.scipy
      python3Packages.tqdm
      python3Packages.uvicorn
      python3Packages.watchdog

      python3Packages.pythonRelaxDepsHook
    ];

    build-system = [
      python3.pkgs.setuptools
      python3.pkgs.wheel
    ];

    pythonImportsCheck = [
      # "rembg"# fails because of cache dir not writable
    ];

    pythonRemoveDeps = ["opencv-python-headless"];

    meta = {
      description = "Rembg is a tool to remove images background";
      homepage = "https://github.com/danielgatis/rembg";
      license = lib.licenses.mit;
      mainProgram = "rembg";
    };
  }
