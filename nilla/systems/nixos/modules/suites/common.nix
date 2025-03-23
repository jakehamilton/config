{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.suites.common;
in
{
  options.plusultra.suites.common = {
    enable = lib.mkEnableOption "the common suite";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ project.packages.list-iommu.result.${pkgs.system} ];

    plusultra = {
      nix.enable = true;

      cli-apps = {
        neovim.enable = true;
        tmux.enable = true;
      };

      tools = {
        git.enable = true;
        misc.enable = true;
        comma.enable = true;
        bottom.enable = true;
      };

      hardware = {
        audio.enable = true;
        storage.enable = true;
        networking.enable = true;
      };

      services = {
        printing.enable = true;
        openssh.enable = true;
        tailscale.enable = true;
      };

      security = {
        gpg.enable = true;
        doas.enable = true;
        keyring.enable = true;
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
