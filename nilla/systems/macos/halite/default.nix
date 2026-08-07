{ config }:
{
  config = {
    colmena.nodes.halite = {
      system = "macos";
      privilegeEscalationCommand = "sudo";

      tags = [
        "workstation"
        "laptop"
        "home"
      ];
    };

    systems.macos.halite = {
      pkgs = config.inputs.nixpkgs.result.aarch64-darwin;
      args = {
        project = config;
        host = "halite";
      };
      modules = [
        ./configuration.nix
        ../modules
      ];
    };
  };
}
