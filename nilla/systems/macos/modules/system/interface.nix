{ config, lib, ... }:

let
  cfg = config.plusultra.system.interface;
in
{
  options.plusultra.system.interface = {
    enable = lib.mkEnableOption "macOS interface";
  };

  config = lib.mkIf cfg.enable {
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

    plusultra.home.file = {
      ".hushlogin".text = "";
    };
  };
}
