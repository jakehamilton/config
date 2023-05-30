{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.plusultra.tools.python;
in
{
  options.plusultra.tools.python = with types; {
    enable = mkBoolOpt false "Whether or not to enable Python.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ python2 python311 ]; };
}
