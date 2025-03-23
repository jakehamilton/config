{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.tools.titan;
in
{
  options.plusultra.tools.titan = {
    enable = lib.mkEnableOption "Titan";

    package = lib.mkOption {
      description = "The package to use.";
      type = lib.types.package;
      default = project.packages.titan.result.${pkgs.system};
    };
  };

  config = lib.mkIf cfg.enable {
    plusultra.tools = {
      # Titan depends on Node and Git
      node.enable = true;
      git.enable = true;
    };

    environment.systemPackages = [ cfg.package ];
  };
}
