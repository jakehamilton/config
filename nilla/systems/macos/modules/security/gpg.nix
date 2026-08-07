{
  lib,
  config,
  pkgs,
  project,
  ...
}:
let
  cfg = config.plusultra.security.gpg;

  gpgConf = "${project.inputs.gpg-base-conf.src}/gpg.conf";

  gpgAgentConf = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
  '';

  guide = "${project.inputs.yubikey-guide.src}/README.md";

  theme = pkgs.fetchFromGitHub {
    owner = "jez";
    repo = "pandoc-markdown-css-theme";
    rev = "019a4829242937761949274916022e9861ed0627";
    sha256 = "1h48yqffpaz437f3c9hfryf23r95rr319lrb3y79kxpxbc9hihxb";
  };

  guideHTML = pkgs.runCommand "yubikey-guide" { } ''
    ${pkgs.pandoc}/bin/pandoc \
      --standalone \
      --metadata title="Yubikey Guide" \
      --from markdown \
      --to html5+smart \
      --toc \
      --template ${theme}/template.html5 \
      --css ${theme}/docs/css/theme.css \
      --css ${theme}/docs/css/skylighting-solarized-theme.css \
      -o $out \
      ${guide}
  '';

  reload-yubikey = pkgs.writeShellScriptBin "reload-yubikey" ''
    ${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye
  '';
in
{
  options.plusultra.security.gpg = {
    enable = lib.mkEnableOption "GPG";
    agentTimeout = lib.mkOption {
      description = "The amount of time to wait before continuing with shell init.";
      type = lib.types.int;
      default = 5;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnupg
      reload-yubikey
    ];

    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)

      ${pkgs.coreutils}/bin/timeout ${builtins.toString cfg.agentTimeout} ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
      gpg_agent_timeout_status=$?

      if [ "$gpg_agent_timeout_status" = 124 ]; then
        # Command timed out...
        echo "GPG Agent timed out..."
        echo 'Run "gpgconf --launch gpg-agent" to try and launch it again.'
      fi
    '';

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    plusultra.home.file = {
      ".gnupg/.keep".text = "";

      ".gnupg/yubikey-guide.md".source = guide;
      ".gnupg/yubikey-guide.html".source = guideHTML;

      ".gnupg/gpg.conf".source = gpgConf;
      ".gnupg/gpg-agent.conf".text = gpgAgentConf;
    };
  };
}
