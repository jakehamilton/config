{ config }:
let
  inherit (config) lib;
in
{
  config.lib.packages = {
    withSystem =
      pkgs: system:
      let
        pkgs' = import pkgs.path {
          inherit system;
          config = pkgs.config;
          overlays = pkgs.overlays;
        };
      in
      pkgs';
  };
}
