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
  cfg = config.${namespace}.apps.logseq;
in
{
  options.${namespace}.apps.logseq = with types; {
    enable = mkBoolOpt false "Whether or not to enable logseq.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ logseq ]; };
}
