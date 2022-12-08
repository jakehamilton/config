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
runCommandNoCC "titan"
{ src = node-packages."@jakehamilton/titan"; }
  ''
    rstrip() {
      # Usage: rstrip "string" "pattern"
      printf '%s\n' "''${1%%$2}"
    }

    mkdir -p $out/bin

    local bin=$src/lib/node_modules/@jakehamilton/titan/bin

    for f in $bin/*.js; do
      ln -s $f $out/bin/$(rstrip "$(basename $f)" ".js")
    done
  ''
