{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.desktop.hyprland;

  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkMerge
    types
    optional
    ;
  inherit (lib.${namespace}) enabled colors;

  pamixer = lib.getExe pkgs.pamixer;

  volumectl = pkgs.writeShellScriptBin "volumectl" ''
    case "$1" in
      up)
        ${pamixer} -i "$2"
        ;;
      down)
        ${pamixer} -d "$2"
        ;;
      mute)
        ${pamixer} -t
        ;;
    esac
  '';
in
{
  options.${namespace}.desktop.hyprland = {
    enable = mkEnableOption "Hyprland";

    package = mkOption {
      type = types.package;
      default = pkgs.hyprland;
      description = "The Hyprland package to use.";
    };

    wallpaper = mkOption {
      type = types.oneOf [
        types.package
        types.path
        types.str
      ];
      default = pkgs.plusultra.wallpapers.nord-rainbow-dark-nix;
      description = "The wallpaper to use.";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra Hyprland settings to apply.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libinput
      volumectl
      playerctl
      brightnessctl
      glib
      gtk3.out
      gnome.gnome-control-center
      ags
      libdbusmenu-gtk3
    ];

    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

    security.pam.services.hyprlock = { };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.greetd.tuigreet} --cmd Hyprland";
        };
      };
    };

    services.upower = enabled;

    programs.dconf = enabled;

    plusultra = {
      system.xkb.enable = true;
      desktop.addons = {
        gtk = enabled;
        wallpapers = enabled;
        electron-support = enabled;
        foot = enabled;
        clipboard = enabled;
        firefox-nordic-theme = enabled;
        ags = {
          # bar = enabled;
        };
      };

      home = {
        # configFile."hypr/hyprpaper.conf".text = ''
        #   preload = ${builtins.toString cfg.wallpaper}
        #   splash = false

        #   wallpaper = , ${builtins.toString cfg.wallpaper}
        # '';

        extraOptions = {
          # systemd.user.services.hyprpaper = {
          #   Unit = {
          #     Description = "Hyprland wallpaper daemon";
          #     PartOf = ["graphical-session.target"];
          #   };

          #   Service = {
          #     ExecStart = lib.getExe pkgs.hyprpaper;
          #     Restart = "on-failure";
          #   };

          #   Install = {
          #     WantedBy = ["graphical-session.target"];
          #   };
          # };

          wayland.windowManager.hyprland = {
            enable = true;

            settings = mkMerge [
              {
                # "$mod" = "SUPER";
                # "$terminal" = "foot";

                # monitor = [
                #   # Default monitor fallback
                #   ", preferred, auto, 1"
                # ];

                input = {
                  repeat_delay = 200;
                  follow_mouse = 2;
                  mouse_refocus = false;

                  kb_options = "caps:escape";

                  touchpad = {
                    natural_scroll = true;
                  };
                };

                general = {
                  layout = "master";

                  border_size = 2;
                  "col.active_border" = "0xff${colors.without-hash colors.nord.nord10}";
                  "col.inactive_border" = "0x00${colors.without-hash colors.nord.nord0}";

                  gaps_out = 16;
                };

                master = {
                  orientation = "center";
                  always_center_master = true;
                };

                dwindle = {
                  preserve_split = true;
                  force_split = 2;
                };

                misc = {
                  disable_hyprland_logo = true;
                  disable_splash_rendering = true;
                };

                gestures = {
                  workspace_swipe = true;
                  workspace_swipe_distance = 100;
                };

                # bind = [
                #   # Hyprland controls
                #   "$mod SHIFT, q, exit"
                #   "$mod SHIFT, r, forcerendererreload"

                #   # Window management
                #   "$mod, h, movefocus, l"
                #   "$mod, l, movefocus, r"
                #   "$mod, j, movefocus, d"
                #   "$mod, k, movefocus, u"
                #   "$mod, left, movefocus, l"
                #   "$mod, right, movefocus, r"
                #   "$mod, up, movefocus, d"
                #   "$mod, down, movefocus, u"

                #   "$mod SHIFT, h, movewindow, l"
                #   "$mod SHIFT, l, movewindow, r"
                #   "$mod SHIFT, j, movewindow, d"
                #   "$mod SHIFT, k, movewindow, u"
                #   "$mod SHIFT, left, movewindow, l"
                #   "$mod SHIFT, right, movewindow, r"
                #   "$mod SHIFT, up, movewindow, d"
                #   "$mod SHIFT, down, movewindow, u"

                #   "$mod, v, togglesplit"
                #   "$mod, q, killactive"

                #   "$mod SHIFT, Space, togglefloating"

                #   "$mod SHIFT, s, pin"

                #   "$mod, f, fullscreen, 0"
                #   "$mod SHIFT, f, fakefullscreen"

                #   # Workspace management
                #   "$mod, 1, workspace, 1"
                #   "$mod, 2, workspace, 2"
                #   "$mod, 3, workspace, 3"
                #   "$mod, 4, workspace, 4"
                #   "$mod, 5, workspace, 5"
                #   "$mod, 6, workspace, 6"
                #   "$mod, 7, workspace, 7"
                #   "$mod, 8, workspace, 8"
                #   "$mod, 9, workspace, 9"
                #   "$mod, 0, workspace, 10"

                #   "$mod SHIFT, 1, movetoworkspace, 1"
                #   "$mod SHIFT, 2, movetoworkspace, 2"
                #   "$mod SHIFT, 3, movetoworkspace, 3"
                #   "$mod SHIFT, 4, movetoworkspace, 4"
                #   "$mod SHIFT, 5, movetoworkspace, 5"
                #   "$mod SHIFT, 6, movetoworkspace, 6"
                #   "$mod SHIFT, 7, movetoworkspace, 7"
                #   "$mod SHIFT, 8, movetoworkspace, 8"
                #   "$mod SHIFT, 9, movetoworkspace, 9"
                #   "$mod SHIFT, 0, movetoworkspace, 10"

                #   "$mod SHIFT Control_L, 1, movetoworkspacesilent, 1"
                #   "$mod SHIFT Control_L, 2, movetoworkspacesilent, 2"
                #   "$mod SHIFT Control_L, 3, movetoworkspacesilent, 3"
                #   "$mod SHIFT Control_L, 4, movetoworkspacesilent, 4"
                #   "$mod SHIFT Control_L, 5, movetoworkspacesilent, 5"
                #   "$mod SHIFT Control_L, 6, movetoworkspacesilent, 6"
                #   "$mod SHIFT Control_L, 7, movetoworkspacesilent, 7"
                #   "$mod SHIFT Control_L, 8, movetoworkspacesilent, 8"
                #   "$mod SHIFT Control_L, 9, movetoworkspacesilent, 9"
                #   "$mod SHIFT Control_L, 0, movetoworkspacesilent, 10"

                #   # Desktop shell integration
                #   "$mod, s, pass, ^(avalanche-bar).*$"

                #   # Programs
                #   "$mod, Return, exec, $terminal"
                # ];

                # bindm = [
                #   # Use `wev` to find the keycodes
                #   "$mod, mouse:272, movewindow"
                #   "$mod, mouse:273, resizewindow"
                # ];

                # bindl = [
                #   ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, preferred, auto, 1\""
                #   ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
                # ];

                binde = [
                  # Media
                  ", XF86AudioMute, exec, volumectl mute"
                  ", XF86AudioLowerVolume, exec, volumectl down 5"
                  ", XF86AudioRaiseVolume, exec, volumectl up 5"
                ];

                windowrule = [ ];

                layerrule = [ "noanim, ^avalanche-" ];

                # Programs to run on startup
                exec-once =
                  [
                    # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                  ]
                  ++ optional config.${namespace}.desktop.addons.gtk.enable
                    "${cfg.package}/bin/hyprctl setcursor \"${config.${namespace}.desktop.addons.gtk.cursor.name}\" 16";

                # Decorations
                decoration = {
                  rounding = 8;
                  drop_shadow = true;
                  shadow_ignore_window = false;
                  active_opacity = 1.0;
                  inactive_opacity = 1.0;

                  blur = {
                    enabled = false;
                  };
                };
              }

              cfg.settings
            ];
          };
        };
      };
    };
  };
}
