{
  vimUtils,
  fetchFromGitHub,
}: let
  pname = "gemini-vim-syntax";
in
  vimUtils.buildVimPlugin {
    inherit pname;
    version = "2021-11-15";
    dontBuild = true;
    src = fetchFromGitHub {
      owner = "lokesh-krishna";
      repo = pname;
      rev = "5ab987496ffeba9c6062c7e6d9ea40effb79ddb5";
      sha256 = "sha256-nDrY3rlnPHux6zCwPoJgMgCvHonn7CCR1qxCUO19/QM=";
    };
    meta.homepage = "https://github.com/lokesh-krishna/${pname}";
  }
