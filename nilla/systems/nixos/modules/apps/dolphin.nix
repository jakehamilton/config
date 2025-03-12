{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.dolphin;
in
{
  options.plusultra.apps.dolphin = {
    enable = lib.mkEnableOption "Dolphin";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dolphin-emu ];

    # Enable GameCube controller support.
    services.udev.packages = with pkgs; [ dolphin-emu ];
  };
}
