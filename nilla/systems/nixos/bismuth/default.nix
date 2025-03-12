{ config }:
let
  inherit (config) lib;
in
{
  config.systems.nixos.bismuth = {
    pkgs = lib.packages.withSystem config.inputs.nixpkgs.loaded "x86_64-linux";
    args = {
      project = config;
      host = "bismuth";
    };
    modules = [
      ./configuration.nix
      ../modules
      config.inputs.home-manager.loaded.nixos
    ];
  };
}
