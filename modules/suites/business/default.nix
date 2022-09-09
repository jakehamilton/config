{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.suites.business;
in {
  options.plusultra.suites.business = with types; {
    enable = mkBoolOpt false "Whether or not to enable business configuration.";
  };

  config =
    mkIf cfg.enable { plusultra = { apps = { frappe-books = enabled; }; }; };
}
