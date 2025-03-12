{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.desktop.gnome;

  gdmHome = config.users.users.gdm.home;

  baseExtensions = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    gsconnect
    gtile
    just-perfection
    logo-menu
    no-overview
    space-bar
    top-bar-organizer
    wireless-hid
  ];

  default-attrs = lib.mapAttrs (name: lib.mkDefault);
  nested-default-attrs = lib.mapAttrs (name: default-attrs);
in
{
  options.plusultra.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME";

    wallpaper = {
      light = lib.mkOption {
        description = "The light wallpaper to apply.";
        type = lib.types.oneOf [
          lib.types.str
          lib.types.package
        ];
        default = project.packages.wallpapers.build.${pkgs.system}.nord-rainbow-light-nix;
      };

      dark = lib.mkOption {
        description = "The dark wallpaper to apply.";
        type = lib.types.oneOf [
          lib.types.str
          lib.types.package
        ];
        default = project.packages.wallpapers.build.${pkgs.system}.nord-rainbow-dark-nix;
      };
    };

    color-scheme = lib.mkOption {
      description = "The color scheme to use.";
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = "dark";
    };

    suspend = lib.mkOption {
      description = "Whether to suspend the system on idle.";
      type = lib.types.bool;
      default = true;
    };

    monitors = lib.mkOption {
      description = "The monitor configuration file to use.";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    extensions = lib.mkOption {
      description = "The GNOME extensions to install.";
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    plusultra.system.xkb.enable = true;
    plusultra.desktop.addons = {
      clipboard.enable = true;
      gtk.enable = true;
      wallpapers.enable = true;
      electron.enable = true;
      foot.enable = true;
    };

    environment.systemPackages =
      baseExtensions
      ++ cfg.extensions
      ++ (with pkgs; [
        gnome-tweaks
        nautilus-python
      ]);

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-tour
        epiphany
        geary
        gnome-font-viewer
        gnome-system-monitor
        gnome-maps
      ]);

    systemd.tmpfiles.rules =
      [ "d ${gdmHome}/.config 0711 gdm gdm" ]
      ++ (
        # "./monitors.xml" comes from ~/.config/monitors.xml when GNOME
        # display information is updated.
        lib.optional (cfg.monitors != null) "L+ ${gdmHome}/.config/monitors.xml - - - - ${cfg.monitors}"
      );

    systemd.services.plusultra-user-icon = {
      before = [ "display-manager.service" ];
      wantedBy = [ "display-manager.service" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
      };

      script = ''
        config_file=/var/lib/AccountsService/users/${config.plusultra.user.name}
        icon_file=/run/current-system/sw/share/plusultra-icons/user/${config.plusultra.user.name}/${config.plusultra.user.icon.fileName}

        if ! [ -d "$(dirname "$config_file")"]; then
          mkdir -p "$(dirname "$config_file")"
        fi

        if ! [ -f "$config_file" ]; then
          echo "[User]
          Session=gnome
          SystemAccount=false
          Icon=$icon_file" > "$config_file"
        else
          icon_config=$(sed -E -n -e "/Icon=.*/p" $config_file)

          if [[ "$icon_config" == "" ]]; then
            echo "Icon=$icon_file" >> $config_file
          else
            sed -E -i -e "s#^Icon=.*$#Icon=$icon_file#" $config_file
          fi
        fi
      '';
    };

    # Required for app indicators
    services.udev.packages = with pkgs; [ gnome-settings-daemon ];

    services.libinput.enable = true;

    services.xserver = {
      enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
        autoSuspend = cfg.suspend;
      };
      desktopManager.gnome.enable = true;
    };

    plusultra.home.extraOptions = {
      dconf.settings =
        let
          user = config.users.users.${config.plusultra.user.name};
          get-wallpaper =
            wallpaper: if lib.isDerivation wallpaper then builtins.toString wallpaper else wallpaper;
        in
        nested-default-attrs {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions =
              (builtins.map (extension: extension.extensionUuid) (cfg.extensions ++ baseExtensions))
              ++ [
                "native-window-placement@gnome-shell-extensions.gcampax.github.com"
                "drive-menu@gnome-shell-extensions.gcampax.github.com"
                "user-theme@gnome-shell-extensions.gcampax.github.com"
              ];
            favorite-apps =
              [ "org.gnome.Nautilus.desktop" ]
              ++ lib.optional config.plusultra.apps.firefox.enable "firefox.desktop"
              ++ lib.optional config.plusultra.apps.vscode.enable "code.desktop"
              ++ lib.optional config.plusultra.desktop.addons.foot.enable "foot.desktop"
              ++ lib.optional config.plusultra.apps.discord.enable "discord.desktop"
              ++ lib.optional config.plusultra.apps.steam.enable "steam.desktop";
          };

          "org/gnome/desktop/background" = {
            picture-uri = get-wallpaper cfg.wallpaper.light;
            picture-uri-dark = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/screensaver" = {
            picture-uri = get-wallpaper cfg.wallpaper.light;
            picture-uri-dark = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/interface" = {
            color-scheme = if cfg.color-scheme == "light" then "default" else "prefer-dark";
            enable-hot-corners = false;
          };
          "org/gnome/desktop/peripherals/mouse" = {
            speed = 0.0;
            accel-profile = "flat";
            natural-scroll = true;
          };
          "org/gnome/desktop/peripherals/touchpad" = {
            disable-while-typing = false;
          };
          "org/gnome/desktop/peripherals/keyboard" = {
            # delay = project.lib.home-manager.hm.gvariant.mkUint32 200;
          };
          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = 10;
            resize-with-right-button = true;
          };
          "org/gnome/desktop/wm/keybindings" = {
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-5 = [ "<Super>5" ];
            switch-to-workspace-6 = [ "<Super>6" ];
            switch-to-workspace-7 = [ "<Super>7" ];
            switch-to-workspace-8 = [ "<Super>8" ];
            switch-to-workspace-9 = [ "<Super>9" ];
            switch-to-workspace-10 = [ "<Super>0" ];

            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            move-to-workspace-5 = [ "<Shift><Super>5" ];
            move-to-workspace-6 = [ "<Shift><Super>6" ];
            move-to-workspace-7 = [ "<Shift><Super>7" ];
            move-to-workspace-8 = [ "<Shift><Super>8" ];
            move-to-workspace-9 = [ "<Shift><Super>9" ];
            move-to-workspace-10 = [ "<Shift><Super>0" ];
          };
          "org/gnome/shell/keybindings" = {
            # Remove the default hotkeys for opening favorited applications.
            switch-to-application-1 = [ ];
            switch-to-application-2 = [ ];
            switch-to-application-3 = [ ];
            switch-to-application-4 = [ ];
            switch-to-application-5 = [ ];
            switch-to-application-6 = [ ];
            switch-to-application-7 = [ ];
            switch-to-application-8 = [ ];
            switch-to-application-9 = [ ];
            switch-to-application-10 = [ ];
          };
          "org/gnome/mutter" = {
            edge-tiling = false;
            dynamic-workspaces = false;
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            autohide = true;
            dock-fixed = false;
            dock-position = "BOTTOM";
            pressure-threshold = 200.0;
            require-pressure-to-show = true;
            show-favorites = true;
            hot-keys = false;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            panel-size = 48;
            activities-button = false;
          };

          "org/gnome/shell/extensions/Logo-menu" = {
            hide-softwarecentre = true;

            # Use right click to open Activities.
            menu-button-icon-click-type = 3;

            # Use the NixOS logo.
            menu-button-icon-image = 23;

            menu-button-terminal =
              if config.plusultra.desktop.addons.term.enable then
                lib.getExe config.plusultra.desktop.addons.term.package
              else
                lib.getExe pkgs.gnome.gnome-terminal;
          };

          "org/gnome/shell/extensions/aylurs-widgets" = {
            background-clock = false;
            battery-bar = false;
            dash-board = false;
            date-menu-date-format = "%H:%M  %B %d";
            date-menu-hide-clocks = true;
            date-menu-hide-system-levels = true;
            date-menu-hide-user = true;

            # Hide the indincator
            date-menu-indicator-position = 2;

            media-player = false;
            media-player-prefer = "firefox";
            notification-indicator = false;
            power-menu = false;
            quick-toggles = false;
            workspace-indicator = false;
          };

          "org/gnome/shell/extensions/top-bar-organizer" = {
            left-box-order = [
              "menuButton"
              "activities"
              "dateMenu"
              "appMenu"
            ];

            center-box-order = [ "Space Bar" ];

            right-box-order = [
              "keyboard"
              "EmojisMenu"
              "wireless-hid"
              "drive-menu"
              "vitalsMenu"
              "screenRecording"
              "screenSharing"
              "dwellClick"
              "a11y"
              "quickSettings"
            ];
          };

          "org/gnome/shell/extensions/space-bar/shortcuts" = {
            enable-activate-workspace-shortcuts = false;
          };
          "org/gnome/shell/extensions/space-bar/behavior" = {
            show-empty-workspaces = false;
          };

          "org/gnome/shell/extensions/gtile" = {
            show-icon = false;
            grid-sizes = "8x2,4x2,2x2";
          };
        };
    };

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    # Open firewall for samba connections to work.
    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
  };
}
