{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.tools.k8s;
in
{
  options.${namespace}.tools.k8s = with types; {
    enable = mkBoolOpt false "Whether or not to enable common Kubernetes utilities.";
  };

  config = mkIf cfg.enable {
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
