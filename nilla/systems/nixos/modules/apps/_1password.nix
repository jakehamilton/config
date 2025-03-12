{ lib, config, ... }:
let
  cfg = config.plusultra.apps._1password;
in
{
  options.plusultra.apps._1password = {
    enable = lib.mkEnableOption "1Password";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      _1password.enable = true;

      _1password-gui = {
        enable = true;

        polkitPolicyOwners = [ config.plusultra.user.name ];
      };
    };
  };
}
