{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.git;

  gpg = config.plusultra.security.gpg;
  user = config.plusultra.user;
in
{
  options.plusultra.tools.git = {
    enable = lib.mkEnableOption "Git";

    userName = lib.mkOption {
      description = "The name to configure Git with.";
      type = lib.types.str;
      default = user.fullName;
    };

    userEmail = lib.mkOption {
      description = "The email to configure Git with.";
      type = lib.types.str;
      default = user.email;
    };

    signingKey = lib.mkOption {
      description = "The key ID to sign commits with.";
      type = lib.types.str;
      default = "9762169A1B35EA68";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];

    plusultra.home.extraOptions = {
      programs.git = {
        enable = true;
        inherit (cfg) userName userEmail;
        lfs.enable = true;
        signing = {
          key = cfg.signingKey;
          signByDefault = lib.mkIf gpg.enable true;
        };
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
          pull = {
            rebase = true;
          };
          push = {
            autoSetupRemote = true;
          };
          core = {
            whitespace = "trailing-space,space-before-tab";
          };
          safe = {
            directory = "${config.users.users.${user.name}.home}/work/config";
          };
        };
      };
    };
  };
}
