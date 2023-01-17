{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.desktop.addons.firefox-nordic-theme;
  profileDir = ".mozilla/firefox/${config.plusultra.user.name}";
in
{
  options.plusultra.desktop.addons.firefox-nordic-theme = with types; {
    enable = mkBoolOpt false "Whether to enable the Nordic theme for firefox.";
  };

  config = mkIf cfg.enable {
    plusultra.apps.firefox = {
      extraConfig = builtins.readFile
        "${pkgs.plusultra.firefox-nordic-theme}/configuration/user.js";
      userChrome = ''
        @import "${pkgs.plusultra.firefox-nordic-theme}/userChrome.css";
      '';
    };
  };
}
