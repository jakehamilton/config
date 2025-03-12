{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.tools.icehouse;
in
{
  options.plusultra.tools.icehouse = {
    enable = lib.mkEnableOption "Icehouse";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      project.inputs.icehouse.loaded.packages.${pkgs.system}.icehouse
    ];
  };
}
