{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.addons.clipboard;

  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.${namespace}.desktop.addons.clipboard = {
    enable = mkEnableOption "Clipboard";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ wl-clipboard ]; };
}
