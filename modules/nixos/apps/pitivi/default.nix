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
  cfg = config.${namespace}.apps.pitivi;
in
{
  options.${namespace}.apps.pitivi = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pitivi.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ pitivi ]; };
}
