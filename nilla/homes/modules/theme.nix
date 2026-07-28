{ pkgs, project, ... }:
let
  inherit (project.lib.colors) base16;
in
{
  config = {
    stylix = {
      enable = true;
      polarity = "dark";

      fonts = {
        serif = {
          name = "DejaVu Serif";
          package = pkgs.dejavu_fonts;
        };

        sansSerif = {
          name = "DejaVu Sans";
          package = pkgs.dejavu_fonts;
        };

        monospace = {
          name = "Hack Nerd Font Mono";
          package = pkgs.nerd-fonts.hack;
        };

        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
      };

      base16Scheme = base16;
    };
  };
}
