{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.thaw;
in
{
  options.${namespace}.cli-apps.thaw = with types; {
    enable = mkBoolOpt false "Whether or not to enable thaw.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ snowfallorg.thaw ]; };
}
