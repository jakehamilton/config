{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.apps.rpcs3;
in
{
  options.plusultra.apps.rpcs3 = with types; {
    enable = mkBoolOpt false "Whether or not to enable rpcs3.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ rpcs3 ];
  };
}
