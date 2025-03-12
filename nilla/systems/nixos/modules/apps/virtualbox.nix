{ lib, config, ... }:
let
  cfg = config.plusultra.apps.virtualbox;
in
{
  options.plusultra.apps.virtualbox = {
    enable = lib.mkEnableOption "VirtualBox";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    plusultra.user.extraGroups = [ "vboxusers" ];
  };
}
