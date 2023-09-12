{ options, config, lib, pkgs, ... }:

with lib;
with lib.plusultra;
let cfg = config.plusultra.tools.python;
in
{
  options.plusultra.tools.python = with types; {
    enable = mkBoolOpt false "Whether or not to enable Python.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        (python311.withPackages (ps:
          with ps; [
            numpy
          ])
        )
      ];
    };
}
