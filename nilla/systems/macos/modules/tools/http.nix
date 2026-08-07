{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.http;
in
{
  options.plusultra.tools.http = {
    enable = lib.mkEnableOption "http utilities";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
      curl
    ];
  };
}
