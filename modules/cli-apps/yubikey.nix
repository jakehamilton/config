{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.cli-apps.yubikey;
in {
  options.plusultra.cli-apps.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable Yubikey.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yubikey-manager ];
  };
}
