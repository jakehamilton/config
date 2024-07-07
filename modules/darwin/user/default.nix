{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf mkDefault;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;

  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;
in
{
  options.${namespace}.user = {
    name = mkOpt types.str "short" "The user account.";

    fullName = mkOpt types.str "Jake Hamilton" "The full name of the user.";
    email = mkOpt types.str "jake.hamilton@hey.com" "The email of the user.";

    uid = mkOpt (types.nullOr types.int) 501 "The uid for the user account.";
  };

  config = {
    users.users.${cfg.name} = {
      # NOTE: Setting the uid here is required for another
      # module to evaluate successfully since it reads
      # `users.users.${plusultra.user.name}.uid`.
      uid = mkIf (cfg.uid != null) cfg.uid;
    };

    snowfallorg.user.${config.${namespace}.user.name}.home.config = {
      home = {
        file = {
          ".profile".text = ''
            # The default file limit is far too low and throws an error when rebuilding the system.
            # See the original with: ulimit -Sa
            ulimit -n 4096
          '';
        };
      };
    };
  };
}
