{ config }:
let
  inherit (config) lib;
in
{
  config.systems.nixos.quartz = {
    pkgs = lib.packages.withSystem config.inputs.nixpkgs.result "x86_64-linux";
    args = {
      project = config;
      host = "quartz";
    };
    modules = [
      ./configuration.nix
      ../modules
      config.inputs.home-manager.result.nixosModules.home-manager
    ];
  };
}
