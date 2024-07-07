{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  namespace,
  ...
}:
let
  src = fetchFromGitHub {
    owner = "jakehamilton";
    repo = "dotbox";
    rev = "27814185c287846f776003650e582efe734831f2";
    sha256 = "sha256-nJDte8rpYq3Ge844qtAOvLp6NcFsl51jFgaZGR97/YI";
    postFetch = ''
      mv $out/packages/website .

      rm -rf $out

      mv website $out
    '';
  };
in
# inherit (lib.importJSON "${src}/package.json") version;
buildNpmPackage {
  name = "dotbox-website";
  verison = "unstable-2022-01-12";

  inherit src;

  npmDepsHash = "sha256-RdRQMrYoOaf2rjhvVpZw0skcekKL8rzG3oFlf/1D1cY";

  installPhase = ''
    mv dist $out
  '';
}
