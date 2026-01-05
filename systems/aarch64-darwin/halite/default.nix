{
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:

let
  python = pkgs.python3;
  python-lsp-server = python.pkgs.python-lsp-server;
in
with lib.${namespace};
{
  plusultra = {
    suites = {
      common = enabled;
      development = enabled;
    };

    desktop.yabai = enabled;

    home.extraOptions = {
      programs.zsh.initExtra = ''
        if [[ -f $HOME/.env ]]; then
          source $HOME/.env
        fi
      '';

      home.sessionPath = [
        "$HOME/.npm-global/bin/"
      ];
    };
  };

  environment.variables = {
    NODE_PATH = "$HOME/.npm-global/";
  };

  environment.systemPackages = [
    pkgs.bun
    pkgs.mariadb

    pkgs.charmbracelet.crush
    pkgs.gopls
    pkgs.typescript-language-server
    pkgs.nixd
    pkgs.vscode-langservers-extracted
    (python-lsp-server.overridePythonAttrs (old: {
      propagatedBuildInputs = old.dependencies ++ python-lsp-server.optional-dependencies.all;
    }))
    # pkgs.podman
    # pkgs.podman-compose
    # pkgs.${namespace}.docker-shim

    pkgs.kubectl
    pkgs.kubecolor
    pkgs.kubeseal
    pkgs.kubespy
    pkgs.kubectx
    pkgs.kubevpn
    pkgs.k3d

    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
        helm-git
        helm-s3
        helm-secrets
        helm-unittest
        helm-mapkubeapis
      ];
    })
  ];

  services.openssh = {
    enable = true;
  };

  documentation.enable = false;

  environment.systemPath = [ "/opt/homebrew/bin" ];

  system.stateVersion = 5;
}
