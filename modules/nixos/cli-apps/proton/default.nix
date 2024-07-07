{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.proton;
in
{
  options.${namespace}.cli-apps.proton = with types; {
    enable = mkBoolOpt false "Whether or not to enable Proton.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ proton-caller ]; };
}
