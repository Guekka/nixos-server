{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication {
  pname = "whisperx";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cvl01";
    repo = "whisperX";
    rev = "bd9b897cd3fdb8c23863cbf9f6517640b5c6bf50";
    hash = "sha256-zS27tM62Ti/NsKqZVjMql/0pvLz+P1LdDxp472kjtdk=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  patches = [
    #./asr.patch
  ];

  propagatedBuildInputs = with python3.pkgs; [
    faster-whisper
    ffmpeg-python
    nltk
    pandas
    pyannote-audio
    setuptools
    torch
    torchaudio
    transformers
  ];

  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "WhisperX:  Automatic Speech Recognition with Word-level Timestamps (& Diarization";
    homepage = "https://github.com/m-bain/whisperX";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [];
    mainProgram = "whisperx";
  };
}
