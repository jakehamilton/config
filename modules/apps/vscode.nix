{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.ultra.apps.vscode;
in
{
  options.ultra.apps.vscode = with types; {
    enable = mkBoolOpt true "Whether or not to enable vscode.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ vscode ];
  };
}
