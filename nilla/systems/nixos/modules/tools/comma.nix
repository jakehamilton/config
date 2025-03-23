{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.tools.comma;
in
{
  options.plusultra.tools.comma = {
    enable = lib.mkEnableOption "Comma";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [ project.packages.nix-update-index.result.${pkgs.system} ]
      ++ (with pkgs; [
        comma
      ]);

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
