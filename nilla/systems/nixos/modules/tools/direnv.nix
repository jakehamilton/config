{ lib, config, ... }:
let
  cfg = config.plusultra.tools.direnv;
in
{
  options.plusultra.tools.direnv = {
    enable = lib.mkEnableOption "Direnv";
  };

  config = lib.mkIf cfg.enable {
    plusultra.home.extraOptions = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
