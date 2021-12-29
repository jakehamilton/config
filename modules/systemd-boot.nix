{ ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 40;
  boot.loader.efi.canTouchEfiVariables = true;
}
