{ options, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.plusultra.suites.development;
  apps = {
    vscode = enabled;
    yubikey = enabled;
  };
  cli-apps = {
    tmux = enabled;
    neovim = enabled;
    yubikey = enabled;
  };
in {
  options.plusultra.suites.development = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      inherit apps cli-apps;

      tools = {
        k8s = enabled;
        node = enabled;
        http = enabled;
        titan = enabled;
        at = enabled;
      };

      virtualisation = { podman = enabled; };
    };
  };
}
