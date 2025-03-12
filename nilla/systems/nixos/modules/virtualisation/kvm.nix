{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.virtualisation.kvm;

  user = config.plusultra.user;
in
{
  options.plusultra.virtualisation.kvm = {
    enable = lib.mkEnableOption "KVM virtualisation";

    vfioIds = lib.mkOption {
      description = "The hardware IDs to pass through to a virtual machine.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    platform = lib.mkOption {
      description = "Which CPU platform the machine is using.";
      type = lib.types.enum [ "amd" "intel" ];
      default = "amd";
    };
  };

  config = lib.mkIf cfg.enable {

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
        # "vfio-pci.ids=${concatStringsSep "," cfg.vfioIds}"
      ];
      extraModprobeConfig = lib.optionalString (builtins.length cfg.vfioIds > 0) ''
        softdep amdgpu pre: vfio vfio-pci
        options vfio-pci ids=${builtins.concatStringsSep "," cfg.vfioIds}
      '';
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
          ovmf.enable = true;
          swtpm.enable = true;
          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString config.users.users.${user.name}.uid}"
          '';
        };
      };
    };

    plusultra = {
      user = {
        extraGroups = [
          "qemu-libvirtd"
          "libvirtd"
          "disk"
        ];
      };
    };
  };
}
