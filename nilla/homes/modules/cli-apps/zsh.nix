{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plusultra.cli-apps.zsh;

  tty-color-support = with lib.plusultra.colors; ''
    if [ "$TERM" = "linux" ]; then
      echo -ne "\e]P0${without-hash palette.black}" # black
      echo -ne "\e]P1${without-hash palette.red-dim}" # darkred
      echo -ne "\e]P9${without-hash palette.red}" # red
      echo -ne "\e]P2${without-hash palette.green-dim}" # darkgreen
      echo -ne "\e]PA${without-hash palette.green}" # green
      echo -ne "\e]P3${without-hash palette.yellow-dim}" # darkyellow
      echo -ne "\e]PB${without-hash palette.yellow}" # yellow
      echo -ne "\e]P4${without-hash palette.blue-dim}" # darkblue
      echo -ne "\e]PC${without-hash palette.blue}" # blue
      echo -ne "\e]P5${without-hash palette.magenta-dim}" # darkmagenta
      echo -ne "\e]PD${without-hash palette.magenta}" # magenta
      echo -ne "\e]P6${without-hash palette.cyan-dim}" # darkcyan
      echo -ne "\e]PE${without-hash palette.cyan}" # cyan
      echo -ne "\e]P7${without-hash palette.white-dim}" # lightgrey
      echo -ne "\e]P8${without-hash palette.black-bright}" # darkgrey
      echo -ne "\e]PF${without-hash palette.white}" # white
      clear
    fi
  '';
in
{
  options.plusultra.cli-apps.zsh = {
    enable = lib.mkEnableOption "ZSH";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        autosuggestion.enable = true;

        initContent = ''
          # Fix an issue with tmux.
          export KEYTIMEOUT=1

          # Use vim bindings.
          set -o vi

          ${tty-color-support}

          ${pkgs.toilet}/bin/toilet -f future "Plus Ultra" --gay

          # Improved vim bindings.
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        '';

        shellAliases = {
          say = "${pkgs.toilet}/bin/toilet -f pagga";
        };

        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.4.0";
              sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
            };
          }
        ];
      };

      starship = {
        enable = true;
        settings = {
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[✗](bold red) ";
            vicmd_symbol = "[](bold blue) ";
          };
        };
      };
    };
  };
}
