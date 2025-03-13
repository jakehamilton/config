{ config }:
let
  inherit (config) lib;
in
{
  config.systems.nixos.albite = {
    pkgs = lib.packages.withSystem config.inputs.nixpkgs.loaded "x86_64-linux";
    args = {
      project = config;
      host = "albite";
    };
    modules = [
      ./configuration.nix
      ../modules
      config.inputs.home-manager.loaded.nixosModules.home-manager
    ];
  };
}
