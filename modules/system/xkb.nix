{ options, config, lib, ... }:

with lib;
let cfg = config.plusultra.system.xkb;
in {
  options.plusultra.system.xkb = with types; {
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
