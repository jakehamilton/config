{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.suites.common-slim;
in
{
  options.plusultra.suites.common-slim = {
    enable = lib.mkEnableOption "the common-slim suite";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ project.packages.list-iommu.build.${pkgs.system} ];

    plusultra = {
      nix.enable = true;

      tools = {
        git.enable = true;
        comma.enable = true;
        bottom.enable = true;
      };

      hardware = {
        storage.enable = true;
        networking.enable = true;
      };

      services = {
        openssh.enable = true;
        tailscale.enable = true;
      };

      security = {
        doas.enable = true;
      };

      system = {
        boot.enable = true;
        fonts.enable = true;
        locale.enable = true;
        time.enable = true;
        xkb.enable = true;
      };
    };
  };
}
