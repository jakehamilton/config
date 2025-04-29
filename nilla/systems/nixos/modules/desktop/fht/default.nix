{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.desktop.fht;
  term = config.plusultra.desktop.addons.term;

  package = project.inputs.fht-compositor.result.packages.${pkgs.system}.fht-compositor.override {
    inherit (pkgs)
      lib
      libGL
      libdisplay-info
      libinput
      seatd
      libxkbcommon
      mesa
      libgbm
      pipewire
      dbus
      wayland
      pkg-config
      rustPlatform
      installShellFiles;
  };

  toml = pkgs.formats.toml { };

  format = {
    inherit (toml) type;
    generate = name: value:
      let
        result = toml.generate name value;
        checked = pkgs.runCommandNoCC "fht-compositor-checked-config" { } ''
          ${lib.getExe package} --config-path '${result}' check-configuration > ./message

          if [ $? -ne 0 ]; then
            echo "FHT compositor configuration is invalid"
            cat ./message
            exit 1
          fi

          touch $out
        '';
      in
      builtins.seq checked result;
  };

  settings = {
    autostart = [
      # Support for XDG autostart
      "${lib.getExe pkgs.dex} -a"
    ];

    env = {
      # Fix up graphical toolkits to work nicely.
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_STYLE_OVERRIDE = "adwaita";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      SDL_BACKEND = "wayland";
    };

    general = {
      layouts = [
        # TODO: For large screens we want to use "centered-master" as the default.
        # We should also provide both layouts and an
        # easy way to switch between them at runtime
        # in case an external monitor is attached.
        "tile"
      ];
    };

    input = {
      keyboard = {
        repeat-rate = 50;
        repeat-delay = 200;
      };

      mouse = {
        # TODO: This should be "linear" for desktops.
        acceleration-profile = "adaptive";

        scroll-method = "two-finger";
        click-method = "click-finger";
        natural-scrolling = true;

        tap-to-click = true;
        tap-button-map = "left-right-middle";

        tap-and-drag = true;
        drag-lock = true;
      };
    };

    keybinds = {
      Super-Return = {
        action = "run-command";
        arg = lib.getExe term.package;
      };

      Super-Control-Shift-q = {
        action = "quit";
      };

      Super-Control-Shift-r = {
        action = "reload-config";
      };

      Super-q = {
        action = "close-focused-window";
      };

      Super-f = {
        action = "fullscreen-focused-window";
      };

      Super-m = {
        action = "maximize-focused-window";
      };

      Super-c = {
        action = "center-floating-window";
      };

      Super-Space = {
        action = "float-focused-window";
      };

      Super-1 = {
        action = "focus-workspace";
        arg = 0;
      };

      Super-Shift-1 = {
        action = "send-focused-window-to-workspace";
        arg = 0;
      };

      Super-2 = {
        action = "focus-workspace";
        arg = 1;
      };

      Super-Shift-2 = {
        action = "send-focused-window-to-workspace";
        arg = 1;
      };

      Super-3 = {
        action = "focus-workspace";
        arg = 2;
      };

      Super-Shift-3 = {
        action = "send-focused-window-to-workspace";
        arg = 2;
      };

      Super-4 = {
        action = "focus-workspace";
        arg = 3;
      };

      Super-Shift-4 = {
        action = "send-focused-window-to-workspace";
        arg = 3;
      };

      Super-5 = {
        action = "focus-workspace";
        arg = 4;
      };

      Super-Shift-5 = {
        action = "send-focused-window-to-workspace";
        arg = 4;
      };

      Super-6 = {
        action = "focus-workspace";
        arg = 5;
      };

      Super-Shift-6 = {
        action = "send-focused-window-to-workspace";
        arg = 5;
      };

      Super-7 = {
        action = "focus-workspace";
        arg = 6;
      };

      Super-Shift-7 = {
        action = "send-focused-window-to-workspace";
        arg = 6;
      };

      Super-8 = {
        action = "focus-workspace";
        arg = 7;
      };

      Super-Shift-8 = {
        action = "send-focused-window-to-workspace";
        arg = 7;
      };

      Super-9 = {
        action = "focus-workspace";
        arg = 8;
      };

      Super-Shift-9 = {
        action = "send-focused-window-to-workspace";
        arg = 8;
      };

      Super-0 = {
        action = "focus-workspace";
        arg = 9;
      };

      Super-Shift-0 = {
        action = "send-focused-window-to-workspace";
        arg = 9;
      };
    };

    mousebinds = {
      Super-Left = "swap-tile";
      Super-Right = "resize-tile";
    };
  };
in
{
  imports = [
    project.inputs.fht-compositor.result.nixosModules.fht-compositor
  ];

  options.plusultra.desktop.fht = {
    enable = lib.mkEnableOption "fht-compositor";

    settings = lib.mkOption {
      inherit (format) type;
      default = settings;
      description = "Configuration options for fht-compositor.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = package;
      description = "The package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fht-compositor = {
      enable = true;
      package = cfg.package;
    };

    plusultra.home = {
      configFile.fht-compositor-config = lib.mkIf (cfg.settings != { }) {
        target = "fht/compositor.toml";
        source = format.generate "fht-compositor-config" cfg.settings;
      };

      extraOptions = {
        home.packages = [ cfg.package ];
      };
    };
  };
}
