{ options, config, pkgs, lib, ... }:

with lib;
with lib.plusultra;
let cfg = config.plusultra.system.interface;
in
{
  options.plusultra.system.interface = with types; {
    enable = mkEnableOption "macOS interface";
  };

  config = mkIf cfg.enable {
    system.defaults = {
      dock.autohide = true;

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleShowScrollBars = "Always";
      };
    };

    plusultra.home.file.".hushlogin".text = "";
  };
}
