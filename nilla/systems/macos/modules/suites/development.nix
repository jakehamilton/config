{ config, lib, ... }:
let
  cfg = config.plusultra.suites.development;
in
{
  options.plusultra.suites.development = {
    enable = lib.mkEnableOption "development configuration";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      apps = {
        ghostty.enable = true;
      };

      cli-apps = {
        neovim.enable = true;
      };

      tools = {
        node.enable = true;
      };
    };
  };
}
