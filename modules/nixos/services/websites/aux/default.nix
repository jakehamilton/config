{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption fetchFromGitHub;
  inherit (lib.plusultra) mkOpt;

  cfg = config.plusultra.services.websites.aux;
in {
  options.plusultra.services.websites.aux = with lib.types; {
    enable = mkEnableOption "nixpkgs.news Website";
    package = mkOpt package pkgs.auxolotl.website "The site package to use.";
    domain = mkOpt str "aux.computer" "The domain to serve the website site on.";

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
