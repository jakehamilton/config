{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.ultra.apps.discord;
in
{
  options.ultra.apps.discord = with types; {
    enable = mkBoolOpt true "Whether or not to enable Discord.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ discord ];
  };
}
