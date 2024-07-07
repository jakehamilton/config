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
  cfg = config.${namespace}.apps.gimp;
in
{
  options.${namespace}.apps.gimp = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gimp.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ gimp ]; };
}
