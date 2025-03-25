{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.adamite = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" ];
      };
    };

    systems.nixos.adamite = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "adamite";
      };
      modules = [
        ./configuration.nix
        ../modules
        config.inputs.home-manager.result.nixosModules.home-manager
      ];
    };
  };
}
