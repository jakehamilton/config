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
  cfg = config.${namespace}.tools.python;
in
{
  options.${namespace}.tools.python = with types; {
    enable = mkBoolOpt false "Whether or not to enable Python.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ (python311.withPackages (ps: with ps; [ numpy ])) ];
  };
}
