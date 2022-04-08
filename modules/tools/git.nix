{ options, config, pkgs, lib, ... }:

with lib;
let
  cfg = config.plusultra.tools.git;
  gpg = config.plusultra.security.gpg;
  user = config.plusultra.user;
in {
  options.plusultra.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];

    plusultra.home.extraOptions = {
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        lfs = enabled;
        signing = {
          key = null;
          signByDefault = mkIf gpg.enable true;
        };
        extraConfig = {
          pull = { rebase = true; };
          core = { whitespace = "trailing-space,space-before-tab"; };
        };
      };
    };
  };
}
