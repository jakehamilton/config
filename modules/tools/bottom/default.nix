{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.tools.bottom;
in
{
  options.plusultra.tools.bottom = with types; {
    enable = mkBoolOpt false "Whether or not to enable Bottom.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottom
    ];
  };
}
