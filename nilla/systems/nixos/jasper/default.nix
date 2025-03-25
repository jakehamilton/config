{ config }:
let
  inherit (config) lib;
in
{
  config.systems.nixos.jasper = {
    pkgs = config.inputs.nixpkgs.result.x86_64-linux;
    args = {
      project = config;
      host = "jasper";
    };
    modules = [
      ./configuration.nix
      ../modules
      config.inputs.home-manager.result.nixosModules.home-manager
    ];
  };
}
