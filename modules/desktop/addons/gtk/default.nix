{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.gtk;
in {
  options.plusultra.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    name = mkOpt str "Nordic-darker-standard-buttons"
      "The name of the GTK theme to apply.";
    pkg = mkOpt package pkgs.nordic "The package to use for the theme.";
  };

  config = mkIf cfg.enable {
    plusultra.home.extraOptions = {
      gtk = {
        enable = true;
        theme = {
          name = cfg.name;
          package = cfg.pkg;
        };
      };
    };
  };
}
