{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.plusultra.cli-apps.yubikey;
in
{
  options.plusultra.cli-apps.yubikey = {
    enable = lib.mkEnableOption "Yubikey CLI";
  };

  config = lib.mkIf cfg.enable {
    services.yubikey-agent.enable = true;
    environment.systemPackages = with pkgs; [ yubikey-manager ];
  };
}
