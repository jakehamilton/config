{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.development;
  apps = {
    vscode = enabled;
    yubikey = enabled;
  };
  cli-apps = {
    tmux = enabled;
    neovim = enabled;
    yubikey = enabled;
    prisma = enabled;
    mods = enabled;
  };
in
{
  options.${namespace}.suites.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      12345
      3000
      3001
      8080
      8081
    ];

    plusultra = {
      inherit apps cli-apps;

      tools = {
        # attic = enabled;
        at = enabled;
        direnv = enabled;
        go = enabled;
        http = enabled;
        k8s = enabled;
        node = enabled;
        titan = enabled;
        qmk = enabled;
      };

      virtualisation = {
        podman = enabled;
      };
    };
  };
}
