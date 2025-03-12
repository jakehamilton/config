{ lib, config, ... }:
let
  cfg = config.plusultra.security.acme;
in
{
  options.plusultra.security.acme = {
    enable = lib.mkEnableOption "ACME";

    email = lib.mkOption {
      description = "The email to use.";
      type = lib.types.str;
      value = config.plusultra.user.email;
    };

    staging = lib.mkOption {
      description = "Whether to use the staging server or not.";
      type = lib.types.bool;
      value = false;
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      defaults = {
        inherit (cfg) email;

        group = lib.mkIf config.services.nginx.enable "nginx";
        server = lib.mkIf cfg.staging "https://acme-staging-v02.api.letsencrypt.org/directory";

        # Reload nginx when certs change.
        reloadServices = lib.optional config.services.nginx.enable "nginx.service";
      };
    };
  };
}
