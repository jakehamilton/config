{ lib
, pkgs
, config
, osConfig ? { }
, format ? "unknown"
, namespace
, ...
}:
with lib.${namespace};
{
  plusultra = {
    user = {
      enable = true;
      name = config.snowfallorg.user.name;
    };

    cli-apps = {
      zsh = enabled;
      tmux = enabled;
      neovim = enabled;
      home-manager = enabled;
    };

    tools = {
      git = enabled;
      direnv = enabled;
    };
  };

  xdg.configFile = {
    "ghostty/config".text = ''
      			background = #2e3440
      			foreground = #d8dee9
      			selection-background = #3f4758
      			selection-foreground = #d8dee9
      			cursor-color = #d8dee9
      			cursor-text = #2e3440
      			palette = 0=#3b4252
      			palette = 1=#bf616a
      			palette = 2=#a3be8c
      			palette = 3=#ebcb8b
      			palette = 4=#81a1c1
      			palette = 5=#b48ead
      			palette = 6=#88c0d0
      			palette = 7=#e5e9f0
      			palette = 8=#4c566a
      			palette = 9=#bf616a
      			palette = 10=#a3be8c
      			palette = 11=#ebcb8b
      			palette = 12=#81a1c1
      			palette = 13=#b48ead
      			palette = 14=#8fbcbb
      			palette = 15=#eceff4
      		'';
  };

  # programs.zsh.shellAliases.docker = "podman";
  # programs.zsh.shellAliases.docker-compose = "podman-compose";


  home.packages = [
    pkgs.plusultra.note
  ];

  home.sessionPath = [ "$HOME/bin" ];

  home.stateVersion = "22.11";
}
