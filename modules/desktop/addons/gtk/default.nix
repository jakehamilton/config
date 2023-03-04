{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.desktop.addons.gtk;
  gdmCfg = config.services.xserver.displayManager.gdm;
in
{
  options.plusultra.desktop.addons.gtk = with types; {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    theme = {
      name = mkOpt str "Nordic-darker"
        "The name of the GTK theme to apply.";
      pkg = mkOpt package pkgs.nordic "The package to use for the theme.";
    };
    cursor = {
      name = mkOpt str "Bibata-Modern-Ice"
        "The name of the cursor theme to apply.";
      pkg = mkOpt package pkgs.plusultra.bibata-cursors "The package to use for the cursor theme.";
    };
    icon = {
      name = mkOpt str "Papirus"
        "The name of the icon theme to apply.";
      pkg = mkOpt package pkgs.papirus-icon-theme "The package to use for the icon theme.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.icon.pkg
      cfg.cursor.pkg
    ];

    environment.sessionVariables = {
      XCURSOR_THEME = cfg.cursor.name;
    };

    plusultra.home.extraOptions = {
      gtk = {
        enable = true;

        theme = {
          name = cfg.theme.name;
          package = cfg.theme.pkg;
        };

        cursorTheme = {
          name = cfg.cursor.name;
          package = cfg.cursor.pkg;
        };

        iconTheme = {
          name = cfg.icon.name;
          package = cfg.icon.pkg;
        };
      };
    };

    # @NOTE(jakehamilton): In order to set the cursor theme in GDM we have to specify it in the
    # dconf profile. However, the NixOS module doesn't provide an easy way to do this so the relevant
    # parts have been extracted from:
    # https://github.com/NixOS/nixpkgs/blob/96e18717904dfedcd884541e5a92bf9ff632cf39/nixos/modules/services/x11/display-managers/gdm.nix
    #
    # @NOTE(jakehamilton): The GTK and icon themes don't seem to affect recent GDM versions. I've
    # left them here as reference for the future.
    programs.dconf.profiles = mkIf gdmCfg.enable {
      gdm =
        let
          customDconf = pkgs.writeTextFile {
            name = "gdm-dconf";
            destination = "/dconf/gdm-custom";
            text = ''
              ${optionalString (!gdmCfg.autoSuspend) ''
                [org/gnome/settings-daemon/plugins/power]
                sleep-inactive-ac-type='nothing'
                sleep-inactive-battery-type='nothing'
                sleep-inactive-ac-timeout=0
                sleep-inactive-battery-timeout=0
              ''}

              [org/gnome/desktop/interface]
              gtk-theme='${cfg.theme.name}'
              cursor-theme='${cfg.cursor.name}'
              icon-theme='${cfg.icon.name}'
            '';
          };

          customDconfDb = pkgs.stdenv.mkDerivation {
            name = "gdm-dconf-db";
            buildCommand = ''
              ${pkgs.dconf}/bin/dconf compile $out ${customDconf}/dconf
            '';
          };
        in
        mkForce (
          pkgs.stdenv.mkDerivation {
            name = "dconf-gdm-profile";
            buildCommand = ''
              # Check that the GDM profile starts with what we expect.
              if [ $(head -n 1 ${pkgs.gnome.gdm}/share/dconf/profile/gdm) != "user-db:user" ]; then
                echo "GDM dconf profile changed, please update gtk/default.nix"
                exit 1
              fi
              # Insert our custom DB behind it.
              sed '2ifile-db:${customDconfDb}' ${pkgs.gnome.gdm}/share/dconf/profile/gdm > $out
            '';
          }
        );
    };
  };
}
