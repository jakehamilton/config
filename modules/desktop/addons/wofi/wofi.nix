{ options, config, lib, pkgs, ... }:

with lib;
let
    cfg = config.ultra.desktop.addons.wofi;
in
{
    options.ultra.desktop.addons.wofi = with types; {
        enable = mkBoolOpt false "Whether to enable the Wofi in the desktop environment.";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        wofi
        wofi-emoji
      ];

      # config -> .config/wofi/config
      # css -> .config/wofi/style.css
      # colors -> $XDG_CACHE_HOME/wal/colors
      # ultra.home.configFile."foot/foot.ini".source = ./foot.ini;
      ultra.home.configFile."wofi/config".source = ./config;
      ultra.home.configFile."wofi/style.css".source = ./style.css;
    };
}
