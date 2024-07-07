{
  lib,
  pkgs,
  runCommandNoCC,
  nodejs,
  namespace,
  ...
}:
let
  raw-node-packages = pkgs.callPackage ./create-node-packages.nix { inherit nodejs; };
  node-packages = lib.mapAttrs (
    key: value: value.override { dontNpmInstall = true; }
  ) raw-node-packages;
in
runCommandNoCC "at"
  {
    src = node-packages."@suchipi/at-js";
    meta = with lib; {
      mainProgram = "@";
      description = "@ - JavaScript stdio transformation tool.";
      homepage = "https://github.com/suchipi/at-js#readme";
      maintainers = with maintainers; [ jakehamilton ];
      license = licenses.mit;
    };
  }
  ''
    mkdir -p $out/bin

    local bin=$src/lib/node_modules/@suchipi/at-js/bin

    for f in $bin/*; do
      ln -s $f $out/bin/$(basename $f)
    done
  ''
