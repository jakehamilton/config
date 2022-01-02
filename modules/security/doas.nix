{ options, config, pkgs, lib, ... }:

with lib;
let
    cfg = config.ultra.security.doas;
in
{
    options.ultra.security.doas = {
        enable = mkBoolOpt true "Whether or not to replace sudo with doas.";
    };

    config = mkIf cfg.enable {
        # Disable sudo
        security.sudo.enable = false;

        # Enable and configure `doas`.
        security.doas = {
            enable = true;
            extraRules = [
                {
                    users = [ config.ultra.user.name ];
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