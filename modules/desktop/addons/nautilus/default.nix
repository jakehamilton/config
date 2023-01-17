{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let cfg = config.plusultra.desktop.addons.nautilus;
in
{
  options.plusultra.desktop.addons.nautilus = with types; {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {
    # Enable support for browsing samba shares.
    services.gvfs.enable = true;
    networking.firewall.extraCommands =
      "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";

    environment.systemPackages = with pkgs; [ gnome.nautilus ];
  };
}
