{ lib
, pkgs
, namespace
, inputs
, ...
}:

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
		};
  };

  environment.systemPackages = [
    pkgs.charmbracelet.crush
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
