{ lib, config, ... }:
let
  cfg = config.plusultra.system.zfs;
in
{
  options.plusultra.system.zfs = {
    enable = lib.mkEnableOption "ZFS support";

    pools = lib.mkOption {
      description = "The ZFS pools to manage.";
      type = lib.types.listOf lib.types.str;
      default = [ "rpool " ];
    };

    auto-snapshot.enable = lib.mkEnableOption "ZFS auto snapshotting";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    services.zfs = {
      autoScrub = {
        enable = true;
        pools = cfg.pools;
      };

      autoSnapshot = lib.mkIf cfg.auto-snapshot.enable {
        enable = true;
        flags = "-k -p --utc";
        weekly = lib.mkDefault 3;
        daily = lib.mkDefault 3;
        hourly = lib.mkDefault 0;
        frequent = lib.mkDefault 0;
        monthly = lib.mkDefault 2;
      };
    };

    plusultra = {
      tools = {
        icehouse.enable = true;
      };
    };
  };
}
