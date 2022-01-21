{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.apps.virtualbox;
in {
  options.plusultra.apps.virtualbox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Virtualbox.";
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    plusultra.user.extraGroups = [ "vboxusers" ];
  };
}
