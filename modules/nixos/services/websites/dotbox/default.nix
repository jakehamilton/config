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

  cfg = config.${namespace}.services.websites.dotbox;
in
{
  options.${namespace}.services.websites.dotbox = with lib.types; {
    enable = mkEnableOption "DotBox Website";
    package = mkOpt package pkgs.plusultra.dotbox-website "The site package to use.";
    domain = mkOpt str "dotbox.dev" "The domain to serve the website site on.";

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
