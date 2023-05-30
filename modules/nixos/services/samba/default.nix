{ lib, config, ... }:

let
  cfg = config.plusultra.services.samba;

  inherit (lib)
    types
    mkEnableOption
    mkIf
    mapAttrs
    optionalAttrs;

  inherit (lib.internal)
    mkOpt
    mkBoolOpt;

  bool-to-yes-no = value: if value then "yes" else "no";

  shares-submodule = with types; submodule ({ name, ... }: {
    options = {
      path = mkOpt str null "The path to serve.";
      public = mkBoolOpt false "Whether the share is public.";
      browseable = mkBoolOpt true "Whether the share is browseable.";
      comment = mkOpt str name "An optional comment.";
      read-only = mkBoolOpt false "Whether the share should be read only.";
      only-owner-editable = mkBoolOpt false "Whether the share is only writable by the system owner (plusultra.user.name).";

      extra-config = mkOpt attrs { } "Extra configuration options for the share.";
    };
  });
in
{
  options.plusultra.services.samba = with types; {
    enable = mkEnableOption "Samba";
    workgroup = mkOpt str "WORKGROUP" "The workgroup to use.";
    browseable = mkBoolOpt true "Whether the shares are browseable.";

    shares = mkOpt (attrsOf shares-submodule) { } "The shares to serve.";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 5357 ];
      allowedUDPPorts = [ 3702 ];
    };

    services.samba-wsdd = {
      enable = true;
      discovery = true;
      workgroup = "WORKGROUP";
    };

    services.samba = {
      enable = true;
      openFirewall = true;

      extraConfig = ''
        browseable = ${bool-to-yes-no cfg.browseable}
      '';

      shares = mapAttrs
        (name: value: {
          inherit (value) path comment;

          public = bool-to-yes-no value.public;
          browseable = bool-to-yes-no value.browseable;
          "read only" = bool-to-yes-no value.read-only;
        } // (optionalAttrs value.only-owner-editable {
          "write list" = config.plusultra.user.name;
          "read list" = "guest, nobody";
          "create mask" = "0755";
        }) // value.extra-config)
        cfg.shares;
    };
  };
}
