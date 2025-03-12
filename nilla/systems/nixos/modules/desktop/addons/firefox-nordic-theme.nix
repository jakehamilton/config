{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.desktop.addons.firefox-nordic-theme;

  package = project.packages.firefox-nordic-theme.build.${pkgs.system};
in
{
  options.plusultra.desktop.addons.firefox-nordic-theme = {
    enable = lib.mkEnableOption "Firefox Nordic Theme";
  };

  config = lib.mkIf cfg.enable {
    plusultra.apps.firefox = {
      extraConfig = builtins.readFile "${package}/configuration/user.js";
      userChrome = ''
        @import "${package}/userChrome.css";
      '';
    };
  };
}
