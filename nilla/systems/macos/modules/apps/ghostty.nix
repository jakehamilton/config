{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plusultra.apps.ghostty;
in
{
  options.plusultra.apps.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
  };

  config = lib.mkIf cfg.enable {
    plusultra.desktop.addons.term = {
      enable = true;
      package = pkgs.ghostty-bin;
    };

    plusultra.home.extraOptions = {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;

        settings = {
          macos-titlebar-style = "hidden";
        };
      };
    };
  };
}
