{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.user;

  is-darwin = pkgs.stdenv.isDarwin;

  home-directory =
    if cfg.name == null then
      null
    else if is-darwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";
in
{
  options.plusultra.user = {
    enable = lib.mkEnableOption "user account configuration";

    name = lib.mkOption {
      description = "The name to use for the user account.";
      type = lib.types.str;
      default = "short";
    };

    fullName = lib.mkOption {
      description = "The full name of the user.";
      type = lib.types.str;
      default = "Jake Hamilton";
    };

    email = lib.mkOption {
      description = "The email address of the user.";
      type = lib.types.str;
      default = "jake.hamilton@hey.com";
    };

    home = lib.mkOption {
      description = "The user's home directory";
      type = lib.types.nullOr lib.types.str;
      default = home-directory;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.name != null;
        message = "plusultra.user.name must be set";
      }
      {
        assertion = cfg.home != null;
        message = "plusultra.user.home must be set";
      }
    ];

    home = {
      username = lib.mkDefault cfg.name;
      homeDirectory = lib.mkDefault cfg.home;
    };
  };
}
