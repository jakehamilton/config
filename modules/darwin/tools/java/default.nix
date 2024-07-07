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
  cfg = config.${namespace}.tools.java;
in
{
  options.${namespace}.tools.java = with types; {
    enable = mkBoolOpt false "Whether or not to enable Java.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ jdk ]; };
}
