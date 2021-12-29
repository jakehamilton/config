{ ... }:

{
  services.xserver = {
    enable = true;

    libinput.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "us";
    xkbOptions = "caps:swapescape";

  };

}
