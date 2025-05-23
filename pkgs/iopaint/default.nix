{
  lib,
  python3,
  fetchFromGitHub,
}: let
  controlnet-aux = python3.pkgs.callPackage ./controlnet-aux.nix {};
  typer-config = python3.pkgs.callPackage ./typer-config.nix {};
in
  python3.pkgs.buildPythonApplication {
    pname = "iopaint";
    version = "unstable-2025-03-18";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "Sanster";
      repo = "IOPaint";
      rev = "7ca4552241c7e2b6f1c4b4146d2f364af1d1dcbd";
      hash = "sha256-GASRVXUx2E32DsSQ2gPfPe1lBcdydccHOs+uLfel/MI=";
    };

    build-system = [
      python3.pkgs.setuptools
      python3.pkgs.wheel
    ];

    dependencies = with python3.pkgs; [
      accelerate
      controlnet-aux
      diffusers
      easydict
      fastapi
      gradio
      huggingface-hub
      loguru
      omegaconf
      opencv-python
      peft
      piexif
      pydantic
      python-multipart
      python-socketio
      rich
      safetensors
      torch
      transformers
      typer
      typer-config
      uvicorn
      yacs
    ];

    pythonImportsCheck = [
      "iopaint"
    ];
    pythonRelaxDeps = true;

    meta = {
      description = "Image inpainting tool powered by SOTA AI Model. Remove any unwanted object, defect, people from your pictures or erase and replace(powered by stable diffusion) any thing on your pictures";
      homepage = "https://github.com/Sanster/IOPaint";
      license = lib.licenses.asl20;
      mainProgram = "iopaint";
    };
  }
