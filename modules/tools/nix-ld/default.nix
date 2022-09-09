{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.tools.nix-ld;
in {
  options.plusultra.tools.nix-ld = with types; {
    enable = mkBoolOpt false "Whether or not to enable nix-ld.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [ nix-alien ];
  };
}
