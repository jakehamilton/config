{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.ultra.nix;
in
{
  options.ultra.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nixFlakes "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    nix = let users = [ "root" config.ultra.user.name ]; in
    {
      package = cfg.package;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      trustedUsers = users;
      allowedUsers = users;
    };
  };
}
