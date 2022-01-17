{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.ultra.tools.misc;
in {
  options.ultra.tools.misc = with types; {
    enable = mkBoolOpt true "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wget curl file nixfmt jq ];
  };
}
