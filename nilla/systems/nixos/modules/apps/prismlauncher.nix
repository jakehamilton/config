{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.prismlauncher;
in
{
  options.plusultra.apps.prismlauncher = {
    enable = lib.mkEnableOption "Prism Launcher";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ prismlauncher ]; };
}
