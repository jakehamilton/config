{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.nix;
in {
  options.plusultra.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nixFlakes "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    nix = let users = [ "root" config.plusultra.user.name ];
    in {
      package = cfg.package;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      trustedUsers = users;
      allowedUsers = users;

      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
