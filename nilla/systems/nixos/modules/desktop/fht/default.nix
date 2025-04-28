{ lib, config, pkgs, project, ... }:
let
  cfg = config.plusultra.desktop.fht;

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

  toml = pkgs.formats.toml {};

  format = {
    inherit (toml) type;
    generate = name: value:
      let
        result = toml.generate name value;
        checked = pkgs.runCommandNoCC "fht-compositor-checked-config" {} ''
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
      configFile.fht-compositor-config = lib.mkIf (cfg.settings != {}) {
        target = "fht/compositor.toml";
        source = format.generate "fht-compositor-config" cfg.settings;
      };

      extraOptions = {
        home.packages = [ cfg.package ];
      };
    };
  };
}
