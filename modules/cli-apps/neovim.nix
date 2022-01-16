{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.cli-apps.neovim;
in {
  options.ultra.cli-apps.neovim = with types; {
    enable = mkBoolOpt true "Whether or not to enable neovim.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ neovim ]; };
}
