{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.dolphin;
in {
  options.plusultra.apps.dolphin = with types; {
    enable = mkBoolOpt false "Whether or not to enable Dolphin.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dolphin-emu ];

    # Enable GameCube controller support.
    services.udev.packages = [ pkgs.dolphinEmu ];
  };
}
