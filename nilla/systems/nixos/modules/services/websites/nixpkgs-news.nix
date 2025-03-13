{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.websites.nixpkgs-news;
in
{
  options.plusultra.services.websites.nixpkgs-news = {
    enable = lib.mkEnableOption "nixpkgs.news Website";

    package = lib.mkOption {
      description = "The site package to use.";
      type = lib.types.package;
      default = project.inputs.nixpkgs-news-website.loaded.packages.${pkgs.system}.default;
    };

    domain = lib.mkOption {
      description = "The domain to serve the website on.";
      type = lib.types.str;
      default = "nixpkgs.news";
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
