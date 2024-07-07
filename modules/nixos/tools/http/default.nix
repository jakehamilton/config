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
  cfg = config.${namespace}.tools.http;
in
{
  options.${namespace}.tools.http = with types; {
    enable = mkBoolOpt false "Whether or not to enable common http utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
      curl
    ];
  };
}
