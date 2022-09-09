{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.pcsx2;
in {
  options.plusultra.apps.pcsx2 = with types; {
    enable = mkBoolOpt false "Whether or not to enable PCSX2.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ pcsx2 ]; };
}
