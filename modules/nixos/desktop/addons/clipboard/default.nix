{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.plusultra.desktop.addons.clipboard;

  inherit (lib) mkIf mkEnableOption mkOption;
in {
  options.plusultra.desktop.addons.clipboard = {
    enable = mkEnableOption "Clipboard";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
