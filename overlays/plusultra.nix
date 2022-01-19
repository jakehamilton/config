inputs@{ lib, ... }:

final: prev:
let
  wallpapers = prev.callPackage (lib.getPackagePath "/wallpapers") inputs;
  firefox-nordic-theme =
    prev.callPackage (lib.getPackagePath "/firefox-nordic-theme") inputs;
in { plusultra = { inherit wallpapers firefox-nordic-theme; }; }
