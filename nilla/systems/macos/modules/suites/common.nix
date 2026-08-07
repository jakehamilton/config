{ config, lib, ... }:
let
  cfg = config.plusultra.suites.common;
in
{
  options.plusultra.suites.common = {
    enable = lib.mkEnableOption "common configuration";
  };

  config = lib.mkIf cfg.enable {
    plusultra = {
      nix.enable = true;
      theme.enable = true;

      cli-apps = {
        neovim.enable = true;
        tmux.enable = true;
      };

      tools = {
        git.enable = true;
      };

      system = {
        fonts.enable = true;
        input.enable = true;
        interface.enable = true;
      };

      security = {
        gpg.enable = true;
      };
    };
  };
}
