{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.ubports-installer;
in
{
  options.plusultra.apps.ubports-installer = with types; {
    enable = mkBoolOpt false "Whether or not to enable the UBPorts Installer.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs.plusultra; [
        ubports-installer
      ];

      services.udev.packages = with pkgs.plusultra; [
        ubports-installer-udev-rules
      ];
    };
}
