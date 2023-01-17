{ config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.virtualisation.kvm;
  user = config.plusultra.user;
in
{
  options.plusultra.virtualisation.kvm = with types; {
    enable = mkBoolOpt false "Whether or not to enable KVM virtualisation.";
    vfioIds = mkOpt (listOf str) [ ]
      "The hardware IDs to pass through to a virtual machine.";
    platform = mkOpt (enum [ "amd" "intel" ]) "amd"
      "Which CPU platform the machine is using.";
    # Use `machinectl` and then `machinectl status <name>` to
    # get the unit "*.scope" of the virtual machine.
    machineUnits = mkOpt (listOf str) [ ]
      "The systemd *.scope units to wait for before starting Scream.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [
        "kvm-${cfg.platform}"
        "vfio_virqfd"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio"
      ];
      kernelParams = [
        "${cfg.platform}_iommu=on"
        "${cfg.platform}_iommu=pt"
        "kvm.ignore_msrs=1"
      ];
      extraModprobeConfig = optionalString (length cfg.vfioIds > 0)
        "options vfio-pci ids=${concatStringsSep "," cfg.vfioIds}";
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${user.name} qemu-libvirtd -"
      "f /dev/shm/scream 0660 ${user.name} qemu-libvirtd -"
    ];

    environment.systemPackages = with pkgs; [ virt-manager ];

    virtualisation = {
      libvirtd = {
        enable = true;
        extraConfig = ''
          user="${user.name}"
        '';

        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu = {
          package = pkgs.qemu_kvm;
          ovmf = enabled;
          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString config.users.users.${user.name}.uid}"
          '';
        };
      };
    };

    plusultra = {
      user = { extraGroups = [ "qemu-libvirtd" "libvirtd" "disk" ]; };

      apps = { looking-glass-client = enabled; };

      home = {
        extraOptions = {
          systemd.user.services.scream = {
            Unit.Description = "Scream";
            Unit.After = [
              "libvirtd.service"
              "pipewire-pulse.service"
              "pipewire.service"
              "sound.target"
            ] ++ cfg.machineUnits;
            Service.ExecStart =
              "${pkgs.scream}/bin/scream -n scream -o pulse -m /dev/shm/scream";
            Service.Restart = "always";
            Service.StartLimitIntervalSec = "5";
            Service.StartLimitBurst = "1";
            Install.RequiredBy = cfg.machineUnits;
          };
        };
      };
    };
  };
}
