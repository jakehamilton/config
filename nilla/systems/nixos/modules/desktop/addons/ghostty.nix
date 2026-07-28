{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plusultra.desktop.addons.ghostty;
in
{
  options.plusultra.desktop.addons.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
  };

  config = lib.mkIf cfg.enable {
    plusultra.desktop.addons.term = {
      enable = true;
      package = pkgs.ghostty;
    };

    plusultra.home.extraOptions = {
      programs.ghostty = {
        enable = true;

        settings = {
          window-decoration = "none";
        };
      };
    };
  };
}
