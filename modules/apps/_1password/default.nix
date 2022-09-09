{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps._1password;
in {
  options.plusultra.apps._1password = with types; {
    enable = mkBoolOpt false "Whether or not to enable 1password.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ _1password _1password-gui ];
  };
}
