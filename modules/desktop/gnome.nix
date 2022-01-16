{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.ultra.desktop.gnome;
  drv = pkgs.stdenv.mkDerivation {
    name = "hello";
    src = ./.;
    installPhase = ''
      mkdir $out
      echo "hello" > $out/message.txt
    '';
  };
in {
  options.ultra.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
  };

  config = mkIf cfg.enable {
    ultra.system.xkb.enable = true;

    services.xserver = {
      enable = true;

      libinput.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    ultra.home.file."hello-world".source = "${drv}/message.txt";
  };

}
