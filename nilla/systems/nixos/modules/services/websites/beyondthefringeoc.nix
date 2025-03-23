{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.websites.beyondthefringeoc;
in
{
  options.plusultra.services.websites.beyondthefringeoc = {
    enable = lib.mkEnableOption "Beyond The Fringe OC Website";

    package = lib.mkOption {
      description = "The site package to use.";
      type = lib.types.package;
      default = project.packages.beyondthefringeoc-website.result.${pkgs.system};
    };

    domains = lib.mkOption {
      description = "The domains to serve the website on.";
      type = lib.types.listOf lib.types.str;
      default = [
        "beyondthefringeoc.com"
        "hairbyjanine.com"
      ];
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

      virtualHosts = lib.foldl
        (
          hosts: domain:
            hosts
            // {
              "${domain}" = {
                enableACME = cfg.acme.enable;
                forceSSL = cfg.acme.enable;

                locations."/" = {
                  root = cfg.package;
                };
              };
            }
        )
        { }
        cfg.domains;
    };
  };
}
