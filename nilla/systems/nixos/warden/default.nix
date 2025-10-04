{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.warden = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" "game" ];
      };
    };

    systems.nixos.warden = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "warden";
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
