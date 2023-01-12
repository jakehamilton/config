{ lib, pkgs, config, ... }:

let
  inherit (lib) mkIf mkOpt mkEnableOption;

  cfg = config.plusultra.security.acme;
in
{
  options.plusultra.security.acme = with lib.types; {
    enable = mkEnableOption "default ACME configuration";
    email = mkOpt str config.plusultra.user.email "The email to use.";
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      defaults = {
        inherit (cfg) email;
      };
    };
  };
}
