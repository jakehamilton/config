{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.suites.emulation;
in
{
  options.plusultra.suites.emulation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable emulation configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      apps = {
        yuzu = enabled;
        pcsx2 = enabled;
        dolphin = enabled;
      };
    };
  };
}
