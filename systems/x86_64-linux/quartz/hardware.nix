{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
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

  swapDevices = [ ];

  networking = {
    # Derived from `head -c 8 /etc/machine-id`
    hostId = "13c9489f";

    useDHCP = lib.mkDefault true;
    # networking.interfaces.enp3s0f0.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp3s0f1.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp5s0f0.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp5s0f1.useDHCP = lib.mkDefault true;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
