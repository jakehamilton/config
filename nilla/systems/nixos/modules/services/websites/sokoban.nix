{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.websites.sokoban;
in
{
  options.plusultra.services.websites.sokoban = {
    enable = lib.mkEnableOption "Sokoban Website";

    package = lib.mkOption {
      description = "The site package to use.";
      type = lib.types.package;
      default = project.packages.sokoban-website.build.${pkgs.system};
    };

    domain = lib.mkOption {
      description = "The domain to serve the website on.";
      type = lib.types.str;
      default = "sokoban.app";
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
