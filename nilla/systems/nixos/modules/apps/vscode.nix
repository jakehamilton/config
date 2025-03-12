{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.apps.vscode;
in
{
  options.plusultra.apps.vscode = {
    enable = lib.mkEnableOption "VSCode";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = with pkgs; [ vscode ]; };
}
