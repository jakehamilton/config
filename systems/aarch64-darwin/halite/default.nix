{ lib
, pkgs
, namespace
, inputs
, ...
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
  ];


  services.openssh = {
    enable = true;
  };

  documentation.enable = false;

  environment.systemPath = [ "/opt/homebrew/bin" ];

  system.stateVersion = 5;
}
