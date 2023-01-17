{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.tools.appimage-run;
in
{
  options.plusultra.tools.appimage-run = with types; {
    enable = mkBoolOpt false "Whether or not to enable appimage-run.";
  };

  config = mkIf cfg.enable {
    plusultra.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      appimage-run
    ];
  };
}
