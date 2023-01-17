{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.apps.pocketcasts;
in
{
  options.plusultra.apps.pocketcasts = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pocketcasts.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.plusultra; [ pocketcasts ];
  };
}
