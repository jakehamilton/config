{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.plusultra.desktop.addons.foot;
in
{
  options.plusultra.desktop.addons.foot = with types; {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {
    plusultra.desktop.addons.term = {
      enable = true;
      pkg = pkgs.foot;
    };

    plusultra.home.configFile."foot/foot.ini".source = ./foot.ini;
  };
}
