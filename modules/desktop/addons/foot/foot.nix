{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.foot;
in
{
    options.ultra.desktop.addons.foot = with types; {
        enable = mkBoolOpt false "Whether to enable the gnome file manager.";
    };

    config = mkIf cfg.enable {
      ultra.desktop.addons.term = {
        enable = true;
        pkg = pkgs.foot;
      };

      ultra.home.configFile."foot/foot.ini".source = ./foot.ini;
    };
}
