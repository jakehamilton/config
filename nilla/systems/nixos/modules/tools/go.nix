{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.go;
in
{
  options.plusultra.tools.go = {
    enable = lib.mkEnableOption "Go";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        go
        gopls
      ];
      sessionVariables = {
        GOPATH = "$HOME/work/go";
      };
    };
  };
}
