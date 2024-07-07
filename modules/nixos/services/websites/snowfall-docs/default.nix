{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption fetchFromGitHub;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.websites.snowfall-docs;
in
{
  options.${namespace}.services.websites.snowfall-docs = with lib.types; {
    enable = mkEnableOption "docs.snowfall.org Website";
    package = mkOpt package pkgs.snowfallorg.snowfall-docs "The site package to use.";
    domain = mkOpt str "snowfall.org" "The domain to serve the website site on.";

    acme = {
      enable = mkOpt bool true "Whether or not to automatically fetch and configure SSL certs.";
    };
  };

  config = mkIf cfg.enable {
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
