{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.appimage-run;
in
{
  options.plusultra.tools.appimage-run = {
    enable = lib.mkEnableOption "appimage-run";
  };

  config = lib.mkIf cfg.enable {
    plusultra.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [ appimage-run ];
  };
}
