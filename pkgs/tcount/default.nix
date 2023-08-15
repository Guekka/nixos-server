{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tcount";
  version = "unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "rrethy";
    repo = "tcount";
    rev = "341d9aa29512257bf7dfd7e843d02fdcfd583387";
    hash = "sha256-M4EvaX9qDBYeapeegp6Ki7FJLFosVR1B42QRAh5Eugo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-bibtex-0.0.1" = "sha256-wgduSxlpbJy/ITenBLfj5lhziUM1BApX6MjXhWcb7lQ=";
      "tree-sitter-c-0.16.0" = "sha256-LsLhCKUfB6uccQ4mBRXxsw7+dDnQmJht0yFGrF6tOuY=";
      "tree-sitter-c-sharp-0.19.0" = "sha256-UHw5JQ++iYLTyqL8KH1impRxXJ2oJAQRoD79nLVQgMw=";
      "tree-sitter-clojure-0.0.8" = "sha256-zdYyLfPFkn0amV5/JUaMkODMPf5jB4NJfvELlZ+IeZI=";
      "tree-sitter-css-0.19.0" = "sha256-jfsLkwvbmt88TmGDejMR4exF5z9zQeXHcHUEuJy2IHk=";
      "tree-sitter-erlang-0.0.1" = "sha256-cH4kFM58nKazI3VQ0QLU2cTh7pXkgPxTFJ5XnLkALt8=";
      "tree-sitter-go-0.19.0" = "sha256-gxMoPAtagkkqg1dOt5Ks4anUKXDRMFekGwb68DfZvp8=";
      "tree-sitter-html-0.19.0" = "sha256-vqtB32K+9pVV7FHEwbC2eNMHOlFgh9DRMjmu49na58E=";
      "tree-sitter-json-0.19.0" = "sha256-F4rgtAVGBEYtUHnhKY0r0MoXnrXYNGIgTjRHqapz5I4=";
      "tree-sitter-julia-0.19.0" = "sha256-wxCWBGUL54yR9AHAA2V7+glNqqxfarDC2wQ/4eGudt0=";
      "tree-sitter-latex-0.0.1" = "sha256-j4jthswAQw3knCUGYntHRr7TZnp+BlWQIRkMOoiiB7c=";
      "tree-sitter-lua-0.0.1" = "sha256-uhKpG1sWMZbN4hIT3d+l7bmOwyaammf72Zi6i0UNbp4=";
      "tree-sitter-query-0.0.1" = "sha256-VW1UTgqzDD8NWvliNwDI6IMls+/TLURnrvSBdtZuUDM=";
      "tree-sitter-ruby-0.19.0" = "sha256-+E+lbyqOfbnckJUPGVl4V3MelhHybbRjYpI6Nzv3WKk=";
      "tree-sitter-scala-0.19.0" = "sha256-x6E2OKCVlxW0JMUDwl782+R73mJFTbfbXIqSB8go6RU=";
    };
  };

  meta = with lib; {
    description = "Count your code by tokens and patterns in the syntax tree. A tokei/scc/cloc alternative";
    homepage = "https://github.com/rrethy/tcount";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
