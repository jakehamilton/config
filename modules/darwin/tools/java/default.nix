{ options, config, lib, pkgs, ... }:

with lib;
with lib.plusultra;
let cfg = config.plusultra.tools.java;
in
{
  options.plusultra.tools.java = with types; {
    enable = mkBoolOpt false "Whether or not to enable Java.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jdk
    ];
  };
}
