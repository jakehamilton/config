{ ... }:

{
    services.xserver = {
        enable = true;

        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        layout = "us";
        xkbOptions = "caps:escape";
    };

}