{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.apps.steam;
in
{
  options.plusultra.apps.steam = {
    enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;

    hardware.steam-hardware.enable = true;

    # Enable GameCube controller support.
    services.udev.packages = with pkgs; [ dolphin-emu ];

    environment.systemPackages = [
      project.packages.steam.result.${pkgs.system}

      # Fixes an issue regarding Steam requiring user namespaces.
      pkgs.bubblewrap
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}
