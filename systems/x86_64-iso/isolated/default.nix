{
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  gpgConf = "${inputs.gpg-base-conf}/gpg.conf";

  gpgAgentConf = ''
    pinentry-program /run/current-system/sw/bin/pinentry-curses
  '';

  guide = "${inputs.yubikey-guide}/README.md";

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

  guideDesktopItem = pkgs.makeDesktopItem {
    name = "yubikey-guide";
    desktopName = "Yubikey Guide";
    genericName = "View Yubikey Guide in a web browser";
    exec = "${pkgs.xdg-utils}/bin/xdg-open ${guideHTML}";
    icon = lib.snowfall.fs.get-file "modules/security/gpg/yubico-icon.svg";
    categories = [ "System" ];
  };

  reload-yubikey = pkgs.writeShellScriptBin "reload-yubikey" ''
    ${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye
  '';
in
{
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  environment.systemPackages = with pkgs; [
    cryptsetup
    gnupg
    pinentry-curses
    pinentry-qt
    paperkey
    wget
    guideDesktopItem
    reload-yubikey
    firefox
  ];

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  plusultra = {
    nix = enabled;

    desktop = {
      gnome = {
        enable = true;
      };
    };

    apps = {
      vscode = enabled;
      firefox = enabled;
    };

    cli-apps = {
      neovim = enabled;
      yubikey = enabled;
    };

    tools = {
      misc = enabled;
      git = enabled;
    };

    home.file."guide.md".source = guide;
    home.file."guide.html".source = guideHTML;
    home.file."gpg.conf".source = gpgConf;
    home.file."gpg-agent.conf".text = gpgAgentConf;

    home.file.".gnupg/gpg.conf".source = gpgConf;
    home.file.".gnupg/gpg-agent.conf".text = gpgAgentConf;

    hardware = {
      networking = {
        # Networking is explicitly disabled in this environment.
        enable = mkForce false;
      };
    };

    security = {
      doas = enabled;
    };

    system = {
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
