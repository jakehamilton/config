{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.doukutsu-rs;
in {
  options.plusultra.apps.doukutsu-rs = with types; {
    enable = mkBoolOpt false "Whether or not to enable doukutsu-rs.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.plusultra; [ doukutsu-rs ];
  };
}
