{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.services.cowsay-mastodon-poster;

  cow2img = project.inputs.cowsay.packages.${pkgs.system}.cow2img;

  script = ''
    if [ ! -f ~/.config/toot/config.json ]; then
      echo "File ~/.config/toot/config.json does not exist. Run 'toot login_cli' first."
      exit 1
    fi

    tmp_dir=$(mktemp -d)

    pushd $tmp_dir > /dev/null
      ${cow2img}/bin/cow2img --no-spinner ${
        if cfg.short then "--message \"$(${pkgs.fortune}/bin/fortune -s)\"" else ""
      }

      cow_name=$(cat ./cow/name)
      cow_message=$(cat ./cow/message)

      post="$cow_name saying:"$'\n\n'"$cow_message"

      ${pkgs.toot}/bin/toot post --media ./cow/image.png --description "$post" "#hachybots"
    popd > /dev/null

    rm -rf $tmp_dir
  '';
in
{
  options.plusultra.services.cowsay-mastodon-poster = {
    enable = lib.mkEnableOption "cowsay mastodon posts";

    short = lib.mkOption {
      description = "Whether to use short fortunes.";
      type = lib.types.bool;
      value = false;
    };

    user = lib.mkOption {
      description = "The user to run as.";
      type = lib.types.str;
      default = config.plusultra.user.name;
    };

    group = lib.mkOption {
      description = "The group to run as.";
      type = lib.types.str;
      default = "users";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      timers.cowsay-mastodon-poster = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          # Run once a day at 10am.
          OnCalendar = "*-*-* 10:00:00";
          Unit = "cowsay-mastodon-poster.service";
        };
      };

      services.cowsay-mastodon-poster = {
        after = [ "network-online.target" ];
        description = "Post a cowsay image to Mastodon.";

        inherit script;

        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
        };
      };
    };
  };
}
