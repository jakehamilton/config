{ options, config, lib, pkgs, ... }:

with lib;
with lib.plusultra;
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

    plusultra.home = {
      configFile = {
        "wgetrc".text = "";
      };

      extraOptions = {
        programs.nix-index.enable = true;
      };
    };
  };
}
