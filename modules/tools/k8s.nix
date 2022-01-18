{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.tools.k8s;
in {
  options.plusultra.tools.k8s = with types; {
    enable = mkBoolOpt true "Whether or not to enable common Kubernetes utilities.";
  };

  config = mkIf cfg.enable {
    programs.zsh.shellAliases = {
      k = "kubecolor";
      kubectl = "kubecolor";
      kc = "kubectx";
      kn = "kubens";
    };

    environment.systemPackages = with pkgs; [
      kubectl
      kubectx
      kubecolor
      kubernetes-helm
      helmfile
    ];
  };
}
