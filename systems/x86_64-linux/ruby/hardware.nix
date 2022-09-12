{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
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


  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking    
  # (the default) this is the recommended approach. When using systemd-networkd it's    
  # still possible to use this option, but it's recommended to use it in conjunction    
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.    
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
} 
