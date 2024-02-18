{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption fetchFromGitHub;
  inherit (lib.plusultra) mkOpt;

  cfg = config.plusultra.services.websites.nixpkgs-news;
in {
  options.plusultra.services.websites.nixpkgs-news = with lib.types; {
    enable = mkEnableOption "nixpkgs.news Website";
    package = mkOpt package pkgs.plusultra.nixpkgs-news "The site package to use.";
    domain = mkOpt str "nixpkgs.news" "The domain to serve the website site on.";

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
