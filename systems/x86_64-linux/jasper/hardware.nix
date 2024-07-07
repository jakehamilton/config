{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}:
# TODO(jakehamilton): Phase most of this out when nixos-hardware
# is updated with Framework support.
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "rpool/local/root";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

    "/home" = {
      device = "rpool/safe/home";
      fsType = "zfs";
    };

    "/persist" = {
      device = "rpool/safe/persist";
      fsType = "zfs";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.enable = true;

  hardware.bluetooth.enable = true;

  # Enable DHCP on the wireless link
  networking = {
    # Derived from `head -c 8 /etc/machine-id`
    hostId = "1cad7839";

    useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp0s20f3.useDHCP = true;
  };
}
