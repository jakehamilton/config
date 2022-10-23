{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.desktop.addons.gtk;
in
{
  options.plusultra.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    theme = {
      name = mkOpt str "Nordic-darker"
        "The name of the GTK theme to apply.";
      pkg = mkOpt package pkgs.nordic "The package to use for the theme.";
    };
    cursor = {
      name = mkOpt str "Nordzy-white-cursors"
        "The name of the cursor theme to apply.";
      pkg = mkOpt package pkgs.nordzy-cursor-theme "The package to use for the cursor theme.";
    };
    icon = {
      name = mkOpt str "Papirus"
        "The name of the icon theme to apply.";
      pkg = mkOpt package pkgs.papirus-icon-theme "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.icon.pkg
    ];

    plusultra.home.extraOptions = {
      gtk = {
        enable = true;

        theme = {
          name = cfg.theme.name;
          package = cfg.theme.pkg;
        };

        cursorTheme = {
          name = cfg.cursor.name;
          package = cfg.cursor.pkg;
        };

        iconTheme = {
          name = cfg.icon.name;
          package = cfg.icon.pkg;
        };
      };
    };
  };
}
