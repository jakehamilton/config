{ lib, pkgs, config, ... }:

let
  inherit (lib) types mkIf;
  inherit (lib.internal) mkBoolOpt mkOpt;
  inherit (pkgs) fortune toot;
  inherit (pkgs.snowfallorg) cow2img;

  cfg = config.plusultra.services.cowsay-mastodon-poster;

  script = ''
    if [ ! -f ~/.config/toot/config.json ]; then
      echo "File ~/.config/toot/config.json does not exist. Run 'toot login_cli' first."
      exit 1
    fi

    tmp_dir=$(mktemp -d)

    pushd $tmp_dir > /dev/null
      ${cow2img}/bin/cow2img --no-spinner ${if cfg.short then "--message \"$(${fortune}/bin/fortune -s)\"" else ""}

      cow_name=$(cat ./cow/name)
      cow_message=$(cat ./cow/message)

      post="$cow_name saying:"$'\n\n'"$cow_message"

      ${toot}/bin/toot post --media ./cow/image.png --description "$post" "#hachybots"
    popd > /dev/null

    rm -rf $tmp_dir
  '';
in
{
  options.plusultra.services.cowsay-mastodon-poster = with types; {
    enable = mkBoolOpt false "Whether or not to enable cowsay posts.";
    short = mkBoolOpt false "Use short fortunes only.";
    user = mkOpt str config.plusultra.user.name "The user to run as.";
    group = mkOpt str "users" "The group to run as.";
  };

  config = mkIf cfg.enable {
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
