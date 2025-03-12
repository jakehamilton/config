{ lib, config, pkgs, ... }:
let
  cfg = config.plusultra.tools.kubernetes;
in
{
  options.plusultra.tools.kubernetes = {
    enable = lib.mkEnableOption "Kubernetes";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases = {
      k = "kubecolor";
      kubectl = "kubecolor";
      kc = "kubectx";
      kn = "kubens";
      ks = "kubeseal";
    };

    environment.systemPackages = with pkgs; [
      kubectl
      kubectx
      kubeseal
      kubecolor
      kubernetes-helm
      helmfile
    ];
  };
}
