{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.cli-apps.wshowkeys;
in {
  options.ultra.cli-apps.wshowkeys = with types; {
    enable = mkBoolOpt true "Whether or not to enable wshowkeys.";
  };

  config =
    mkIf cfg.enable {
      ultra.user.extraGroups = [ "input" ];
      environment.systemPackages = with pkgs; [ wshowkeys ];
    };
}
