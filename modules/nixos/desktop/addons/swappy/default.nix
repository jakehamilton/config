{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.plusultra.desktop.addons.swappy;
in
{
  options.plusultra.desktop.addons.swappy = with types; {
    enable =
      mkBoolOpt false "Whether to enable Swappy in the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ swappy ];

    plusultra.home.configFile."swappy/config".source = ./config;
    plusultra.home.file."Pictures/screenshots/.keep".text = "";
  };
}
