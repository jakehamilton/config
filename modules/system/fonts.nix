{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.system.fonts;
in {
  options.plusultra.system.fonts = with types; {
    enable = mkBoolOpt true "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      font-manager
    ];

    fonts.fonts = with pkgs;
      [
        noto-fonts
        noto-fonts-emoji
        (nerdfonts.override { fonts = [ "Hack" ]; })
      ] ++ cfg.fonts;
  };
}
