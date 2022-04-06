{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.plusultra.tools.titan;
  pkg = if lib.not null config.plusultra.tools.titan.pkg then
    config.plusultra.tools.titan.pkg
  else
    (pkgs.plusultra.nodePackages."@jakehamilton/titan-5.6.0".override {
      dontNpmInstall = true;
    });
in {
  options.plusultra.tools.titan = with types; {
    enable = mkBoolOpt false "Whether or not to install Titan.";
    pkg = mkOpt (nullOr package) null "The package to install as Titan.";
  };

  config = mkIf cfg.enable {
    plusultra.tools = {
      # Titan depends on Node and Git
      node = enabled;
      git = enabled;
    };

    environment.systemPackages = [
      (pkgs.runCommandNoCC "titan" { } ''
        mkdir -p $out/bin

        ln -s ${pkg}/lib/node_modules/@jakehamilton/titan/bin/titan.js $out/bin/titan
      '')
    ];
  };
}
