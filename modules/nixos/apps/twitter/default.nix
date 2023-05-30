{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.apps.twitter;
in
{
  options.plusultra.apps.twitter = with types; {
    enable = mkBoolOpt false "Whether or not to enable Twitter.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs.plusultra; [ twitter ]; };
}
