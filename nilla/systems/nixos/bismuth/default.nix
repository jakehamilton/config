{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.bismuth = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "workstation" "gaming" "desktop" "home" ];
      };
    };

    systems.nixos.bismuth = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "bismuth";
      };
      modules = [
        ./configuration.nix
        ../modules
        config.inputs.home-manager.result.nixosModules.home-manager
      ];
    };
  };
}
