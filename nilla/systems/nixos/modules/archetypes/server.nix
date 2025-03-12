{ lib, config, ... }:
let
  cfg = config.plusultra.archetypes.server;
in
{
  options.plusultra.archetypes.server = {
    enable = lib.mkEnableOption "the server archetype";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      suites = {
        common-slim.enable = true;
      };

      cli-apps = {
        neovim.enable = true;
        tmux.enable = true;
      };
    };
  };
}
