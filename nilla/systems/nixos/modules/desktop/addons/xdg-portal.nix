{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.desktop.addons.xdg-portal;
in
{
  options.plusultra.desktop.addons.xdg-portal = {
    enable = lib.mkEnableOption "XDG Portal integration";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        gtkUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };
  };
}
