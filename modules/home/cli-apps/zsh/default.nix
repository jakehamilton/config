{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.cli-apps.zsh;

  tty-color-support = with lib.${namespace}.colors; ''
    if [ "$TERM" = "linux" ]; then
      echo -ne "\e]P0${without-hash nord.nord0}" # black
      echo -ne "\e]P8${without-hash nord.nord3}" # darkgrey
      echo -ne "\e]P1${without-hash nord.nord11}" # darkred
      echo -ne "\e]P9${without-hash nord.nord11}" # red
      echo -ne "\e]P2${without-hash nord.nord14}" # darkgreen
      echo -ne "\e]PA${without-hash nord.nord14}" # green
      echo -ne "\e]P3${without-hash nord.nord12}" # brown
      echo -ne "\e]PB${without-hash nord.nord13}" # yellow
      echo -ne "\e]P4${without-hash nord.nord10}" # darkblue
      echo -ne "\e]PC${without-hash nord.nord10}" # blue
      echo -ne "\e]P5${without-hash nord.nord15}" # darkmagenta
      echo -ne "\e]PD${without-hash nord.nord15}" # magenta
      echo -ne "\e]P6${without-hash nord.nord8}" # darkcyan
      echo -ne "\e]PE${without-hash nord.nord8}" # cyan
      echo -ne "\e]P7${without-hash nord.nord5}" # lightgrey
      echo -ne "\e]PF${without-hash nord.nord6}" # white
      clear
    fi
  '';
in
{
  options.${namespace}.cli-apps.zsh = {
    enable = mkEnableOption "ZSH";
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        autosuggestion.enable = true;

        initExtra = ''
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
