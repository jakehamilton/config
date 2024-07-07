{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.qmk;
in
{
  options.${namespace}.tools.qmk = with types; {
    enable = mkBoolOpt false "Whether or not to enable QMK";
  };

  config = mkIf cfg.enable {
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
