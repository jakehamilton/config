{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.tools.comma;
in
{
  options.plusultra.tools.comma = with types; {
    enable = mkBoolOpt false "Whether or not to enable comma.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      comma
      plusultra.nix-update-index
    ];

    plusultra.home.extraOptions = { programs.nix-index.enable = true; };
  };
}
