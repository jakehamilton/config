{ options, config, pkgs, lib, ... }:

with lib;
with lib.plusultra;
let
  cfg = config.plusultra.tools.titan;
in
{
  options.plusultra.tools.titan = with types; {
    enable = mkBoolOpt false "Whether or not to install Titan.";
    pkg = mkOpt package pkgs.plusultra.titan "The package to install as Titan.";
  };

  config = mkIf cfg.enable {
    plusultra.tools = {
      # Titan depends on Node and Git
      node = enabled;
      git = enabled;
    };

    environment.systemPackages = [
      cfg.pkg
    ];
  };
}
