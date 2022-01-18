{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.cli-apps.wshowkeys;
in {
  options.plusultra.cli-apps.wshowkeys = with types; {
    enable = mkBoolOpt true "Whether or not to enable wshowkeys.";
  };

  config =
    mkIf cfg.enable {
      plusultra.user.extraGroups = [ "input" ];
      environment.systemPackages = with pkgs; [ wshowkeys ];
    };
}
