{ lib, config, ... }:
let
  cfg = config.plusultra.system.xkb;
in
{
  options.plusultra.system.xkb = {
    enable = lib.mkEnableOption "XKB configuration";
  };

  config = lib.mkIf cfg.enable {
    console.useXkbConfig = true;

    services.xserver = {
      xkb = {
        layout = "us";
        options = "caps:escape";
      };
    };
  };
}
