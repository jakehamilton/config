{ lib, config, ... }:
let
  cfg = config.plusultra.suites.development;
in
{
  options.plusultra.suites.development = {
    enable = lib.mkEnableOption "the development suite";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      12345
      3000
      3001
      8080
      8081
    ];

    plusultra = {
      apps = {
        vscode.enable = true;
        yubikey.enable = true;
      };

      cli-apps = {
        tmux.enable = true;
        neovim.enable = true;
        yubikey.enable = true;
      };

      tools = {
        direnv.enable = true;
        go.enable = true;
        http.enable = true;
        kubernetes.enable = true;
        node.enable = true;
        titan.enable = true;
        qmk.enable = true;
      };

      virtualisation = {
        podman.enable = true;
      };
    };
  };
}
