{ project, ... }:
{
  imports = [
    ./apps
    ./archetypes
    ./cli-apps
    ./desktop
    ./hardware
    ./security
    ./services
    ./suites
    ./system
    ./tools
    ./user
    ./virtualisation
    ./home.nix
    ./nix.nix

    # project.inputs.home-manager.result.nixosModules.home-manager
    # project.modules.nixos.lix
  ];
}
