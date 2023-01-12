{ lib, fetchFromGitHub, buildNpmPackage, ... }:

let
  src = fetchFromGitHub {
    owner = "jakehamilton";
    repo = "jakehamilton.dev";
    rev = "d2cabf2700c04b5c7a59cf0759b1cffe840fc2b4";
    sha256 = "sha256-2N3QXGCaIe6Z8JwHmojSwYMYrtN8wClLJEKQm03qcSw=";
    postFetch = ''
      mv $out/src .

      rm -rf $out

      mv src $out
    '';
  };
in
src
