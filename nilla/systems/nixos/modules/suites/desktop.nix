{ lib, config, ... }:
let
  cfg = config.plusultra.suites.desktop;
in
{
  options.plusultra.suites.desktop = {
    enable = lib.mkEnableOption "the desktop suite";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      desktop = {
        gnome.enable = true;

        addons = {
          wallpapers.enable = true;
        };
      };

      apps = {
        _1password.enable = true;
        firefox.enable = true;
        vlc.enable = true;
        gparted.enable = true;
      };
    };
  };
}
