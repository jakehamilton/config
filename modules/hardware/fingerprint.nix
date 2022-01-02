{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.ultra.hardware.fingerprint;
in
{
  options.ultra.hardware.fingerprint = with types; {
    enable = mkBoolOpt true "Whether or not to enable fingerprint support.";
  };

  config = mkIf cfg.enable {
    services.fprintd.enable = true;
  };
}
