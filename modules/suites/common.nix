{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.plusultra.suites.common;
in {
  options.plusultra.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      nix = enabled;

      tools = {
        git = enabled;
        misc = enabled;
      };

      hardware = {
        audio = enabled;
        storage = enabled;
        networking = enabled;
      };

      services = { printing = enabled; };

      security = {
        doas = enabled;
        keyring = enabled;
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
