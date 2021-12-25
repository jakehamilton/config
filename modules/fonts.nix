{ pkgs, ... }:

{
    fonts.fonts = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        (nerdfonts.override {
            fonts = [ "Hack" "DroidSansMono" ];
        })
    ];
}