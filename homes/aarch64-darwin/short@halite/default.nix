{
  lib,
  pkgs,
  config,
  osConfig ? { },
  format ? "unknown",
  namespace,
  ...
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
      background = #1E1A24
      foreground = #EEEAF1
      selection-background = #2E2B3D
      selection-foreground = #EEEAF1
      cursor-color = #EEEAF1
      cursor-text = #14111B

      # Colors (regular, bold)
      # Black
      palette = 0=#181520
      palette = 8=#827889

      # Red (Sakura)
      palette = 1=#E598B8
      palette = 9=#F6B7D1

      # Green (Mint)
      palette = 2=#91D5C7
      palette = 10=#B4EFE3

      # Yellow (Peach)
      palette = 3=#E8B0A0
      palette = 11=#F4C8BD

      # Blue (Sky)
      palette = 4=#A8C9E7
      palette = 12=#D1E4F3

      # Purple (Berry)
      palette = 5=#CE98BD
      palette = 13=#E8BADA

      # Aqua (Mint... again)
      palette = 6=#91D5C7
      palette = 14=#B4EFE3

      # White
      palette = 7=#EEEAF1
      palette = 15=#FEFEFE
    '';
  };

  # programs.zsh.shellAliases.docker = "podman";
  # programs.zsh.shellAliases.docker-compose = "podman-compose";

  programs.zsh.shellAliases = {
    k = "kubecolor";
    kubectl = "kubecolor";
    kc = "kubectx";
    kn = "kubens";
    ks = "kubeseal";
  };

  home.packages = [
    pkgs.plusultra.note
  ];

  home.sessionPath = [ "$HOME/bin" ];

  home.stateVersion = "22.11";
}
