{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.desktop.addons.gtk;
in
{
  options.plusultra.desktop.addons.gtk = {
    enable = lib.mkEnableOption "GTK theming";

    theme = {
      name = lib.mkOption {
        description = "The name of the GTK theme to apply.";
        type = lib.types.str;
        default = "Nordic-darker";
      };

      package = lib.mkOption {
        description = "The package to use for the theme.";
        type = lib.types.package;
        default = pkgs.nordic;
      };
    };

    cursor = {
      name = lib.mkOption {
        description = "The name of the cursor theme to apply.";
        type = lib.types.str;
        default = "Bibata-Modern-Ice";
      };

      package = lib.mkOption {
        description = "The package to use for the cursor theme.";
        type = lib.types.package;
        default = pkgs.bibata-cursors;
      };
    };

    icon = {
      name = lib.mkOption {
        description = "The name of the icon theme to apply.";
        type = lib.types.str;
        default = "Papirus";
      };

      package = lib.mkOption {
        description = "The package to use for the icon theme.";
        type = lib.types.package;
        default = pkgs.papirus-icon-theme;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.icon.package
      cfg.cursor.package
    ];

    environment.sessionVariables = {
      XCURSOR_THEME = cfg.cursor.name;
    };

    plusultra.home.extraOptions = {
      gtk = {
        enable = true;

        theme = {
          name = cfg.theme.name;
          package = cfg.theme.package;
        };

        cursorTheme = {
          name = cfg.cursor.name;
          package = cfg.cursor.package;
        };

        iconTheme = {
          name = cfg.icon.name;
          package = cfg.icon.package;
        };
      };
    };
  };
}
