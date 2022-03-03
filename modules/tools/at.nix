{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.plusultra.tools.at;
  pkg = if lib.not null config.plusultra.tools.at.pkg then
    config.plusultra.tools.at.pkg
  else
    (pkgs.plusultra.nodePackages."@suchipi/at-js-0.1.1".override {
      dontNpmInstall = true;
    });
in {
  options.plusultra.tools.at = with types; {
    enable = mkBoolOpt false "Whether or not to install at.";
    pkg = mkOpt (nullOr package) null "The package to install as at.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.runCommandNoCC "at" { } ''
        mkdir -p $out/bin

        ln -s ${pkg}/lib/node_modules/@suchipi/at-js/bin/@ $out/bin/@
        ln -s ${pkg}/lib/node_modules/@suchipi/at-js/bin/@call $out/bin/@call
        ln -s ${pkg}/lib/node_modules/@suchipi/at-js/bin/@for-each $out/bin/@for-each
        ln -s ${pkg}/lib/node_modules/@suchipi/at-js/bin/@join $out/bin/@join
        ln -s ${pkg}/lib/node_modules/@suchipi/at-js/bin/@map $out/bin/@map
        ln -s ${pkg}/lib/node_modules/@suchipi/at-js/bin/@split $out/bin/@split
      '')
    ];
  };
}
