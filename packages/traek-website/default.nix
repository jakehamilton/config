{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  src = fetchFromGitHub {
    owner = "jakehamilton";
    repo = "traek.app";
    rev = "a94c9c98e5b6e6ea0f0d9a53848be28435c53540";
    sha256 = "sha256-HjJ/t+nFXeDrTRE0kJSV1ZSk0SP7w38prNm9rPOkRh8";
  };

  new-meta = with lib; {
    description = "The website for [traek.app](https://traek.app).";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };
  package = buildNpmPackage {
    name = "dotbox-website";
    verison = "unstable-2022-01-12";

    inherit src;

    npmDepsHash = "sha256-VLvqA+a/VmEt2oF1DK4LyUNeUwgGklc1Aeh+sV7DA1k";

    npmFlags = [ "--legacy-peer-deps" ];
    NODE_OPTIONS = "--openssl-legacy-provider";

    buildPhase = ''
      npm run build -- --no-prerender
    '';

    installPhase = ''
      mv build $out
    '';
  };
in
override-meta new-meta package
