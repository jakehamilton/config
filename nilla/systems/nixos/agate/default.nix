{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.agate = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" ];
      };
    };

    systems.nixos.agate = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "agate";
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
