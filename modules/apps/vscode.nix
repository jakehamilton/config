{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.vscode;
in {
  options.plusultra.apps.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to enable vscode.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ vscode ]; };
}
