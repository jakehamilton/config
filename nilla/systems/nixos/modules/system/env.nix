{ lib, config, project, ... }:
let
  cfg = config.plusultra.system.env;
in
{
  options.plusultra.system.env = lib.mkOption {
    description = "A set of environment variables to set.";
    type = lib.types.attrsOf (lib.types.oneOf [
      lib.types.str
      lib.types.path
      (lib.types.listOf (lib.types.either lib.types.str lib.types.path))
    ]);
    apply = builtins.mapAttrs (
      n: v: if lib.isList v then lib.concatMapStringsSep ":" (x: builtins.toString x) v else (builtins.toString v)
    );
    default = { };
  };

  config = {
    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME";
      };
      variables = {
        # Make some programs "XDG" compliant.
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      };
      extraInit = builtins.concatStringsSep "\n" (project.lib.attrs.mapToList (n: v: ''export ${n}="${v}"'') cfg);
    };
  };
}
