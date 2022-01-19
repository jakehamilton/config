{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.yubikey;
in {
  options.plusultra.apps.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable Yubikey.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yubikey-manager yubikey-manager-qt ];
  };
}
