{ lib, pkgs, runCommandNoCC, nodejs, ... }:

let
  raw-node-packages = pkgs.callPackage ./create-node-packages.nix {
    inherit nodejs;
  };
  node-packages = lib.mapAttrs
    (key: value: value.override {
      dontNpmInstall = true;
    })
    raw-node-packages;
in
runCommandNoCC "at"
{ src = node-packages."@suchipi/at-js"; meta.mainProgram = "@"; }
  ''
    mkdir -p $out/bin

    local bin=$src/lib/node_modules/@suchipi/at-js/bin

    for f in $bin/*; do
      ln -s $f $out/bin/$(basename $f)
    done
  ''
