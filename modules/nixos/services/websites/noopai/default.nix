{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    fetchFromGitHub
    foldl
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.websites.noop-ai;
in
{
  options.${namespace}.services.websites.noop-ai = with lib.types; {
    enable = mkEnableOption "noop.ai Website";
    package = mkOpt package pkgs.noop-ai-website "The site package to use.";
    domains = mkOpt (listOf str) [ "noop.ai" ] "The domain to serve the website site on.";

    acme = {
      enable = mkOpt bool true "Whether or not to automatically fetch and configure SSL certs.";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      commonHttpConfig = ''
        types {
          application/javascript mjs;
        }
      '';

      virtualHosts = foldl (
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
      ) { } cfg.domains;
    };
  };
}
