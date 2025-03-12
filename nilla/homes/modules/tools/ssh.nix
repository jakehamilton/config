{ lib, config, ... }:
let
  cfg = config.plusultra.tools.ssh;
in
{
  options.plusultra.tools.ssh = {
    enable = lib.mkEnableOption "SSH";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      extraConfig = ''
        Host *
          HostKeyAlgorithms +ssh-rsa
      '';
    };
  };
}
