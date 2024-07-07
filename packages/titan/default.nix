{
  lib,
  pkgs,
  runCommandNoCC,
  nodejs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  raw-node-packages = pkgs.callPackage ./create-node-packages.nix { inherit nodejs; };

  node-packages = lib.mapAttrs (
    key: value: value.override { dontNpmInstall = true; }
  ) raw-node-packages;

  new-meta = with lib; {
    description = "A little tool for big (monorepo) projects.";
    homepage = "https://www.npmjs.com/package/@jakehamilton/titan";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };
  package = runCommandNoCC "titan" { src = node-packages."@jakehamilton/titan"; } ''
    rstrip() {
      # Usage: rstrip "string" "pattern"
      printf '%s\n' "''${1%%$2}"
    }

    mkdir -p $out/bin

    local bin=$src/lib/node_modules/@jakehamilton/titan/bin

    for f in $bin/*.js; do
      ln -s $f $out/bin/$(rstrip "$(basename $f)" ".js")
    done
  '';
in
override-meta new-meta package
