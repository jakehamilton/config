{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.websites.jakehamilton;
in
{
  options.plusultra.services.websites.jakehamilton = {
    enable = lib.mkEnableOption "DotBox Website";

    package = lib.mkOption {
      description = "The site package to use.";
      type = lib.types.package;
      default = project.inputs.jakehamilton-website.loaded.packages.${pkgs.system}.default;
    };

    domains = lib.mkOption {
      description = "The domains to serve the website on.";
      type = lib.types.listOf lib.types.str;
      default = [
        "jakehamilton.dev"
        "jakehamilton.website"
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
      commonHttpConfig = ''
        types {
          application/javascript mjs;
        }
      '';

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
