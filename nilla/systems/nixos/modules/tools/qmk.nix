{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.qmk;
in
{
  options.plusultra.tools.qmk = {
    enable = lib.mkEnableOption "QMK";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qmk
      keymapper
    ];

    services.udev.packages = with pkgs; [
      qmk-udev-rules
      zsa-udev-rules
    ];
  };
}
