{ config }:
let
  inherit (config) lib;
in
{
  config = {
    colmena.nodes.quartz = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "nas" "desktop" "home" ];
      };
    };

    systems.nixos.quartz = {
      pkgs = config.inputs.nixpkgs.result.x86_64-linux;
      args = {
        project = config;
        host = "quartz";
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
