{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.ubports-installer;
in
{
  options.${namespace}.apps.ubports-installer = with types; {
    enable = mkBoolOpt false "Whether or not to enable the UBPorts Installer.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.plusultra; [ ubports-installer ];

    services.udev.packages = with pkgs.plusultra; [ ubports-installer-udev-rules ];
  };
}
