{ config }:
let
  inherit (config) lib;
in
{
  includes = [
    ./adamite
    ./agate
    ./albite
    ./bismuth
    ./jasper
    ./quartz
    ./warden
  ];

  config.modules = {
    nilla = {
      nixos-system-adamite = ./adamite;
      nixos-system-agate = ./agate;
      nixos-system-albite = ./albite;
      nixos-system-bismuth = ./bismuth;
      nixos-system-jasper = ./jasper;
      nixos-system-quartz = ./quartz;
    };

    nixos = {
      apps = ./modules/apps;

      apps-1password = ./modules/apps/1password.nix;
      apps-ardour = ./modules/apps/ardour.nix;
      apps-blender = ./modules/apps/blender.nix;
      apps-discord = ./modules/apps/discord.nix;
      apps-dolphin = ./modules/apps/dolphin.nix;
      apps-firefox = ./modules/apps/firefox.nix;
      apps-gparted = ./modules/apps/gparted.nix;
      apps-inkscape = ./modules/apps/inkscape.nix;
      apps-obs = ./modules/apps/obs.nix;
      apps-prismlauncher = ./modules/apps/prismlauncher.nix;
      apps-steam = ./modules/apps/steam.nix;
      apps-steamtinkerlaunch = ./modules/apps/steamtinkerlaunch.nix;
      apps-virtualbox = ./modules/apps/virtualbox.nix;
      apps-vlc = ./modules/apps/vlc.nix;
      apps-vscode = ./modules/apps/vscode.nix;
      apps-yubikey = ./modules/apps/yubikey.nix;

      archetypes = ./modules/archetypes;

      archetypes-gaming = ./modules/archetypes/gaming.nix;
      archetypes-server = ./modules/archetypes/server.nix;
      archetypes-workstation = ./modules/archetypes/workstation.nix;

      cli-apps = ./modules/cli-apps;

      cli-apps-neovim = ./modules/cli-apps/neovim.nix;
      cli-apps-tmux = ./modules/cli-apps/tmux.nix;
      cli-apps-yubikey = ./modules/cli-apps/yubikey.nix;

      desktop = ./modules/desktop;

      desktop-addons = ./modules/desktop/addons;

      desktop-addons-clipboard = ./modules/desktop/addons/clipboard.nix;
      desktop-addons-electron = ./modules/desktop/addons/electron.nix;
      desktop-addons-firefox-nordic-theme = ./modules/desktop/addons/firefox-nordic-theme.nix;
      desktop-addons-foot = ./modules/desktop/addons/foot.nix;
      desktop-addons-gtk = ./modules/desktop/addons/gtk.nix;
      desktop-addons-keyring = ./modules/desktop/addons/keyring.nix;
      desktop-addons-term = ./modules/desktop/addons/term.nix;
      desktop-addons-wallpapers = ./modules/desktop/addons/wallpapers.nix;
      desktop-addons-xdg-portal = ./modules/desktop/addons/xdg-portal.nix;

      desktop-gnome = ./modules/desktop/gnome;

      hardware = ./modules/hardware;

      hardware-audio = ./modules/hardware/audio.nix;
      hardware-fingerprint = ./modules/hardware/fingerprint.nix;
      hardware-networking = ./modules/hardware/networking.nix;
      hardware-storage = ./modules/hardware/storage.nix;

      security = ./modules/security;

      security-gpg = ./modules/security/gpg;
      security-acme = ./modules/security/acme.nix;
      security-doas = ./modules/security/doas.nix;
      security-keyring = ./modules/security/keyring.nix;

      services = ./modules/services;

      services-websites = ./modules/services/websites;

      services-websites-beyondthefringeoc = ./modules/services/websites/beyondthefringeoc.nix;
      services-websites-dotbox = ./modules/services/websites/dotbox.nix;
      services-websites-jakehamilton = ./modules/services/websites/jakehamilton.nix;
      services-websites-lasersandfeelings = ./modules/services/websites/lasersandfeelings.nix;
      services-websites-nixpkgs-news = ./modules/services/websites/nixpkgs-news.nix;
      services-websites-noop-ai = ./modules/services/websites/noop-ai.nix;
      services-websites-pungeonquest = ./modules/services/websites/pungeonquest.nix;
      services-websites-retrospectacle = ./modules/services/websites/retrospectacle.nix;
      services-websites-scrumfish = ./modules/services/websites/scrumfish.nix;
      services-websites-snowfall = ./modules/services/websites/snowfall.nix;
      services-websites-sokoban = ./modules/services/websites/sokoban.nix;
      services-websites-traek = ./modules/services/websites/traek.nix;

      services-avahi = ./modules/services/avahi.nix;
      services-cowsay-mastodon-poster = ./modules/services/cowsay-mastodon-poster.nix;
      services-homer = ./modules/services/homer.nix;
      services-openssh = ./modules/services/openssh.nix;
      services-printing = ./modules/services/printing.nix;
      services-samba = ./modules/services/samba.nix;
      services-tailscale = ./modules/services/tailscale.nix;

      suites = ./modules/suites;

      suites-art = ./modules/suites/art.nix;
      suites-common-slim = ./modules/suites/common-slim.nix;
      suites-common = ./modules/suites/common.nix;
      suites-desktop = ./modules/suites/desktop.nix;
      suites-development = ./modules/suites/development.nix;
      suites-emulation = ./modules/suites/emulation.nix;
      suites-games = ./modules/suites/games.nix;
      suites-media = ./modules/suites/media.nix;
      suites-music = ./modules/suites/music.nix;
      suites-social = ./modules/suites/social.nix;
      suites-video = ./modules/suites/video.nix;

      system = ./modules/system;

      system-boot = ./modules/system/boot.nix;
      system-env = ./modules/system/env.nix;
      system-fonts = ./modules/system/fonts.nix;
      system-locale = ./modules/system/locale.nix;
      system-time = ./modules/system/time.nix;
      system-xkb = ./modules/system/xkb.nix;
      system-zfs = ./modules/system/zfs.nix;

      tools = ./modules/tools;

      tools-appimage-run = ./modules/tools/appimage-run.nix;
      tools-bottom = ./modules/tools/bottom.nix;
      tools-comma = ./modules/tools/comma.nix;
      tools-direnv = ./modules/tools/direnv.nix;
      tools-git = ./modules/tools/git.nix;
      tools-go = ./modules/tools/go.nix;
      tools-http = ./modules/tools/http.nix;
      tools-icehouse = ./modules/tools/icehouse.nix;
      tools-kubernetes = ./modules/tools/kubernetes.nix;
      tools-misc = ./modules/tools/misc.nix;
      tools-node = ./modules/tools/node.nix;
      tools-qmk = ./modules/tools/qmk.nix;
      tools-titan = ./modules/tools/titan.nix;

      user = ./modules/user;

      virtualisation = ./modules/virtualisation;

      virtualisation-kvm = ./modules/virtualisation/kvm.nix;
      virtualisation-podman = ./modules/virtualisation/podman.nix;

      home = ./modules/home.nix;

      nix = ./modules/nix.nix;

      lix = (import "${config.inputs.lix.result}/module.nix" {
        lix = (lib.paths.into.drv config.inputs.lix-src.src) // {
          rev = "latest";
        };
      });
    };
  };
}
