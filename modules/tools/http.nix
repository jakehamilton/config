{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.tools.http;
in {
  options.ultra.tools.http = with types; {
    enable = mkBoolOpt true "Whether or not to enable common http utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wget curl ];
  };
}
