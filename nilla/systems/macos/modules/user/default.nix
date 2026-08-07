{
  lib,
  config,
  pkgs,
  project,
  ...
}:
let
  cfg = config.plusultra.user;

  defaultIconFileName = "profile.png";

  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {
      fileName = defaultIconFileName;
    };
  };

  propagatedIcon =
    pkgs.runCommand "propagated-icon"
      {
        passthru = {
          fileName = cfg.icon.fileName;
        };
      }
      ''
        local target="$out/share/plusultra-icons/user/${cfg.name}"
        mkdir -p "$target"

        cp ${cfg.icon} "$target/${cfg.icon.fileName}"
      '';
in
{
  options.plusultra.user = {
    name = lib.mkOption {
      description = "The name to use for the user account.";
      type = lib.types.str;
      default = "short";
    };

    fullName = lib.mkOption {
      description = "The full name of the user.";
      type = lib.types.str;
      default = "Jake Hamilton";
    };

    email = lib.mkOption {
      description = "The email address of the user.";
      type = lib.types.str;
      default = "jake.hamilton@hey.com";
    };

    initialPassword = lib.mkOption {
      description = "The initial password for the user.";
      type = lib.types.str;
      default = "password";
    };

    icon = lib.mkOption {
      description = "The icon to use for the user account.";
      type = lib.types.nullOr lib.types.package;
      default = defaultIcon;
    };

    prompt-init = lib.mkOption {
      description = "Whether or not to show an initial message when opening a new shell.";
      type = lib.types.bool;
      default = true;
    };

    uid = lib.mkOption {
      description = "The user id for the user (typically from `id -u`).";
      type = lib.types.int;
      default = 501;
    };
  };

  config = {
    environment.systemPackages = [
      propagatedIcon
    ]
    ++ (with pkgs; [
      cowsay
      fortune
      lolcat
    ]);

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      histFile = "$XDG_CACHE_HOME/zsh.history";
    };

    plusultra.home = {
      extraOptions = {
        home.shellAliases = {
          lc = "${pkgs.colorls}/bin/colorls --sd";
          lcg = "lc --gs";
          lcl = "lc -1";
          lclg = "lc -1 --gs";
          lcu = "${pkgs.colorls}/bin/colorls -U";
          lclu = "${pkgs.colorls}/bin/colorls -U -1";
        };

        programs = {
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

              # Improved vim bindings.
              source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
            ''
            + lib.optionalString cfg.prompt-init ''
              ${pkgs.toilet}/bin/toilet -f future "Plus Ultra" --gay
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
        };
      };
    };

    users.users.${cfg.name} = {
      inherit (cfg) uid;
    };

    system.primaryUser = cfg.name;

    plusultra.home.file = {
      ".profile".text = ''
        # The default file limit is far too low and throws an error when rebuilding the system.
        # See the original with: ulimit -Sa
        ulimit -n 4096
      '';
    };
  };
}
