{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.yuzu;
in {
  options.plusultra.apps.yuzu = with types; {
    enable = mkBoolOpt false "Whether or not to enable Yuzu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yuzu-mainline ];
  };
}
