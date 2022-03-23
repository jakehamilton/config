inputs@{ lib, ... }:

final: prev:
let
  wallpapers = prev.callPackage (lib.getPackagePath "/wallpapers") inputs;
  firefox-nordic-theme =
    prev.callPackage (lib.getPackagePath "/firefox-nordic-theme") inputs;
  nodePackages = prev.callPackage (lib.getPackagePath "/node-packages") {
    pkgs = prev;
    nodejs = prev.nodejs-17_x;
  };
  cowsay-plus = prev.callPackage (lib.getPackagePath "/cowsay-plus") inputs;
in {
  plusultra = {
    inherit wallpapers firefox-nordic-theme nodePackages cowsay-plus;
  };
}
