{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.gparted;
in
{
  options.plusultra.apps.gparted = {
    enable = lib.mkEnableOption "GParted";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ gparted ]; };
}
