{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.ultra.tools.git;
in {
  options.ultra.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git.";
    userName = mkOpt types.str config.ultra.user.fullName
      "The name to configure git with.";
    userEmail = mkOpt types.str config.ultra.user.email
      "The email to configure git with.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ git ]; };
}
