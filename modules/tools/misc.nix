{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.tools.misc;
in {
  options.plusultra.tools.misc = with types; {
    enable = mkBoolOpt false "Whether or not to enable common utilities.";
  };

  config = mkIf cfg.enable {
    plusultra.home.configFile."wgetrc".text = "";

    environment.systemPackages = with pkgs; [
      fzf
      killall
      unzip
      file
      nixfmt
      nix-prefetch-git
      jq
      clac
      fup-repl
      wget
    ];
  };
}
