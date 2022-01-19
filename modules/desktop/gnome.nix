{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.desktop.gnome;
  drv = pkgs.stdenv.mkDerivation {
    name = "hello";
    src = ./.;
    installPhase = ''
      mkdir $out
      echo "hello" > $out/message.txt
    '';
  };
in {
  options.plusultra.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
  };

  config = mkIf cfg.enable {
    plusultra.system.xkb.enable = true;
    plusultra.desktop.addons = {
      gtk = enabled;
      wallpapers = enabled;
    };

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    plusultra.home.file."hello-world".source = "${drv}/message.txt";
  };

}
