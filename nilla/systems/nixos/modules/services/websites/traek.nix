{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.websites.traek;
in
{
  options.plusultra.services.websites.traek = {
    enable = lib.mkEnableOption "traek.app Website";

    package = lib.mkOption {
      description = "The site package to use.";
      type = lib.types.package;
      default = project.packages.traek-website.build.${pkgs.system};
    };

    domain = lib.mkOption {
      description = "The domain to serve the website on.";
      type = lib.types.str;
      default = "dotbox.traek.app";
    };

    acme.enable = lib.mkOption {
      description = "Whether to automatically fetch and configure SSL certs.";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts.${cfg.domain} = {
        enableACME = cfg.acme.enable;
        forceSSL = cfg.acme.enable;

        locations."/" = {
          root = cfg.package;
        };
      };
    };
  };
}
