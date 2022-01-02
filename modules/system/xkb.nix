{ options, config, lib, ... }:

with lib;
let
  cfg = config.ultra.system.xkb;
in
{
  options.ultra.system.xkb = with types; {
    enable = mkBoolOpt true "Whether or not to configure xkb.";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "us";
      xkbOptions = "caps:escape";
    };
  };
}
