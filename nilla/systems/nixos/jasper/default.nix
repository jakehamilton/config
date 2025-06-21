{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.jasper = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "workstation" "laptop" "mobile" ];
      };
    };

    systems.nixos.jasper = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "jasper";
      };
      modules = [
        ./configuration.nix
        ../modules
        config.inputs.home-manager.result.nixosModules.home-manager
        config.modules.nixos.lix
        config.inputs.framework-fan-control.result.nixosModules.default
      ];
    };
  };
}
