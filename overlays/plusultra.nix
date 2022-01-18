inputs@{ lib, ... }:

final: prev:
let
  wallpapers = prev.callPackage (lib.getPackagePath "/wallpapers") inputs;
in
{
  plusultra = {
    inherit wallpapers;
  };
}
