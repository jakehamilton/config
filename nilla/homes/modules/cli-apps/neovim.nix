{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.cli-apps.neovim;
in
{
  options.plusultra.cli-apps.neovim = {
    enable = lib.mkEnableOption "NeoVim";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        project.inputs.neovim.result.packages.${pkgs.system}.neovim
      ] ++ (with pkgs; [
        less
      ]);

      sessionVariables = {
        PAGER = "less";
        MANPAGER = "less";
        NPM_CONFIG_PREFIX = "$HOME/.npm-global";
        EDITOR = "nvim";
      };

      shellAliases = {
        vimdiff = "nvim -d";
      };
    };

    xdg.configFile = {
      "dashboard-nvim/.keep".text = "";
    };
  };
}
