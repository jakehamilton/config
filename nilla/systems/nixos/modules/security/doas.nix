{ lib, config, ... }:
let
  cfg = config.plusultra.security.doas;
in
{
  options.plusultra.security.doas = {
    enable = lib.mkEnableOption "doas";
  };

  config = lib.mkIf cfg.enable {
    # Disable sudo
    security.sudo.enable = false;

    # Enable and configure `doas`.
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = [ config.plusultra.user.name ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };

    # Add an alias to the shell for backward-compat and convenience.
    environment.shellAliases = {
      sudo = "doas";
    };
  };
}
