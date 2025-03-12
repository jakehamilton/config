{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.homer;

  yaml-format = pkgs.formats.yaml { };
  settings-yaml = yaml-format.generate "config.yml" cfg.settings;

  settings-path =
    if cfg.settings-path != null then cfg.settings-path else builtins.toString settings-yaml;
in
{
  options.plusultra.services.homer = {
    enable = lib.mkEnableOption "Homer";

    package = lib.mkOption {
      description = "The package of Homer assets to use.";
      type = lib.types.package;
      default = project.packages.homer.build.${pkgs.system};
    };

    settings = lib.mkOption {
      description = "Configuration for Homer's config.yml file.";
      type = yaml-format.type;
      default = { };
    };

    settings-path = lib.mkOption {
      description = "A replacement for the generated config.yml file.";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    host = lib.mkOption {
      description = "The host to serve Homer on.";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    nginx.forceSSL = {
      description = "Whether or not to force the use of SSL.";
      type = lib.types.bool;
      default = false;
    };

    acme.enable = lib.mkEnableOption "automatic SSL certificate generation";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.host != null;
        message = "plusultra.services.homer.host must be set.";
      }
      {
        assertion = cfg.settings-path != null -> cfg.settings == { };
        message = "plusultra.services.homer.settings and plusultra.services.homer.settings-path are mutually exclusive.";
      }
      {
        assertion = cfg.nginx.forceSSL -> cfg.acme.enable;
        message = "plusultra.services.homer.nginx.forceSSL requires setting plusultra.services.homer.acme.enable to true.";
      }
    ];

    services.nginx = {
      enable = true;

      virtualHosts."${cfg.host}" = {
        enableACME = cfg.acme.enable;
        forceSSL = cfg.nginx.forceSSL;

        locations."/" = {
          root = "${cfg.package}/share/homer";
        };

        locations."= /assets/config.yml" = {
          alias = settings-path;
        };
      };
    };
  };
}
