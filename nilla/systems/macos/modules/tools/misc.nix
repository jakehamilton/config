{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.misc;
in
{
  options.plusultra.tools.misc = {
    enable = lib.mkEnableOption "miscellaneous tools";
  };

  config = lib.mkIf cfg.enable {
    plusultra.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      fzf
      killall
      unzip
      file
      jq
      clac
      wget
      glow
    ];
  };
}
