{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.titan;
in
{
  options.${namespace}.tools.titan = with types; {
    enable = mkBoolOpt false "Whether or not to install Titan.";
    pkg = mkOpt package pkgs.plusultra.titan "The package to install as Titan.";
  };

  config = mkIf cfg.enable {
    plusultra.tools = {
      # Titan depends on Node and Git
      node = enabled;
      git = enabled;
    };

    environment.systemPackages = [ cfg.pkg ];
  };
}
