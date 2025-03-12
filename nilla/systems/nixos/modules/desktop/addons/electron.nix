{ lib, config, ... }:
let
  cfg = config.plusultra.desktop.addons.electron;
in
{
  options.plusultra.desktop.addons.electron = {
    enable = lib.mkEnableOption "Electron support";
  };

  config = lib.mkIf cfg.enable {
    plusultra.home.configFile."electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
