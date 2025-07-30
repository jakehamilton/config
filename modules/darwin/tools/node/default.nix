{ options
, config
, pkgs
, lib
, namespace
, inputs
, ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.node;
  node18 = inputs.nixpkgs-2411.legacyPackages.${pkgs.system}.nodejs_18;
in
{
  options.${namespace}.tools.node = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git";
    pkg = mkOpt package node18 "The NodeJS package to use";
    prettier = {
      enable = mkBoolOpt true "Whether or not to install Prettier";
      pkg = mkOpt package pkgs.nodePackages.prettier "The NodeJS package to use";
    };
    yarn = {
      enable = mkBoolOpt true "Whether or not to install Yarn";
      pkg = mkOpt package pkgs.nodePackages.yarn "The NodeJS package to use";
    };
    pnpm = {
      enable = mkBoolOpt true "Whether or not to install Pnpm";
      pkg = mkOpt package pkgs.nodePackages.pnpm "The NodeJS package to use";
    };
    flyctl = {
      enable = mkBoolOpt true "Whether or not to install flyctl";
      pkg = mkOpt package pkgs.flyctl "The flyctl package to use";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [ cfg.pkg ]
      ++ (lib.optional cfg.prettier.enable cfg.prettier.pkg)
      ++ (lib.optional cfg.yarn.enable (cfg.yarn.pkg.override {
        nodejs = node18;
      }))
      ++ (lib.optional cfg.pnpm.enable cfg.pnpm.pkg)
      ++ (lib.optional cfg.flyctl.enable cfg.flyctl.pkg);
  };
}
