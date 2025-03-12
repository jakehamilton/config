{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.node;
in
{
  options.plusultra.tools.node = {
    enable = lib.mkEnableOption "Node";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      bun
      nodePackages.prettier
      nodePackages.yarn
      nodePackages.pnpm
    ];
  };
}
