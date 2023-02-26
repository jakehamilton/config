{ lib, pkgs, config, virtual, ... }:

let
  inherit (lib) mkIf mkEnableOption optional;
  inherit (lib.internal) mkOpt;

  cfg = config.plusultra.security.acme;
in
{
  options.plusultra.security.acme = with lib.types; {
    enable = mkEnableOption "default ACME configuration";
    email = mkOpt str config.plusultra.user.email "The email to use.";
    staging = mkOpt bool virtual "Whether to use the staging server or not.";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      defaults = {
        inherit (cfg) email;

        group = mkIf config.services.nginx.enable "nginx";
        server = mkIf cfg.staging "https://acme-staging-v02.api.letsencrypt.org/directory";

        # Reload nginx when certs change.
        reloadServices = optional config.services.nginx.enable "nginx.service";
      };
    };
  };
}
