{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.twitter;
in
{
  options.plusultra.apps.twitter = with types; {
    enable = mkBoolOpt false "Whether or not to enable Twitter.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs.plusultra; [ twitter ]; };
}
