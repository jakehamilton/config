{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.albite = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" ];
      };
    };

    systems.nixos.albite = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "albite";
      };
      modules = [
        ./configuration.nix
        ../modules
        config.inputs.home-manager.result.nixosModules.home-manager
        config.modules.nixos.lix
      ];
    };
  };
}
