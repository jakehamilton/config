{ lib, config, pkgs, ... }:
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
    pkgs.runCommandNoCC "propagated-icon"
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

    extraGroups = lib.mkOption {
      description = "Groups for the user to be assigned to.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    extraOptions = lib.mkOption {
      description = "Extra options passed to `users.users.<name>`.";
      type = lib.types.attrs;
      default = { };
    };
  };

  config = {
    environment.systemPackages =
      [ propagatedIcon ]
      ++ (with pkgs; [
        cowsay
        fortune
        lolcat
      ]);

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      histFile = "$XDG_CACHE_HOME/zsh.history";
    };

    plusultra.home = {
      file = {
        "Desktop/.keep".text = "";
        "Documents/.keep".text = "";
        "Downloads/.keep".text = "";
        "Music/.keep".text = "";
        "Pictures/.keep".text = "";
        "Videos/.keep".text = "";
        "work/.keep".text = "";
        ".face".source = cfg.icon;
        "Pictures/${cfg.icon.fileName or (builtins.baseNameOf cfg.icon)}".source = cfg.icon;
      };

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

            initExtra =
              ''
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
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.zsh;

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      uid = 1000;

      extraGroups = [ "steamcmd" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
