{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.tools.qmk;
in
{
  options.plusultra.tools.qmk = with types; {
    enable = mkBoolOpt false "Whether or not to enable QMK";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qmk
    ];

    services.udev.packages = with pkgs; [
      qmk-udev-rules
    ];
  };
}
