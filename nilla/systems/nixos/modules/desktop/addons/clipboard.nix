{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.desktop.addons.clipboard;
in
{
  options.plusultra.desktop.addons.clipboard = {
    enable = lib.mkEnableOption "Clipboard Support";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ wl-clipboard ]; };
}
