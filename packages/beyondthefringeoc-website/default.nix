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
    repo = "beyondthefringeoc";
    rev = "6408d9260c4e01e46b5bef348e25dd0e9d5e401d";
    sha256 = "sha256-JXds39Dlto6kMwQ4aigWBbtEYLUESkjtuj4f0WjSp90";
    postFetch = ''
      mv $out/app .

      rm -rf $out

      mv app $out
    '';
  };

  new-meta =
    with lib;
    src.meta
    // {
      description = "The website for beyondthefringeoc.com.";
      maintainers = with maintainers; [ jakehamilton ];
    };
in
override-meta new-meta src
