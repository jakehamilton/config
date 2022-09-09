{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.plusultra.tools.at;
  pkg =
    if config.plusultra.tools.at.pkg != null then
      config.plusultra.tools.at.pkg
    else
      (pkgs.plusultra.node-packages."@suchipi/at-js-0.4.0".override {
        dontNpmInstall = true;
      });
in
{
  options.plusultra.tools.at = with types; {
    enable = mkBoolOpt false "Whether or not to install at.";
    pkg = mkOpt (nullOr package) null "The package to install as at.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.runCommandNoCC "at" { src = pkg; } ''
        mkdir -p $out/bin

        local bin=$src/lib/node_modules/@suchipi/at-js/bin

        for f in $bin/*; do
          ln -s $f $out/bin/$(basename $f)
        done
      '')
    ];
  };
}
