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
    prisma = enabled;
  };
in
{
  options.plusultra.suites.development = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common development configuration.";
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
        direnv = enabled;
        k8s = enabled;
        node = enabled;
        http = enabled;
        titan = enabled;
        at = enabled;
        go = enabled;
      };

      virtualisation = { podman = enabled; };
    };
  };
}
