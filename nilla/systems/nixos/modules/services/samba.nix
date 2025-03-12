{ lib, config, ... }:
let
  cfg = config.plusultra.services.samba;

  bool-to-yes-no = value: if value then "yes" else "no";

  shares-submodule =
    lib.types.submodule (
      { name, ... }:
      {
        options = {
          path = lib.mkOption {
            description = "The path to serve.";
            type = lib.types.str;
          };
          public = lib.mkOption {
            description = "Whether the share is public.";
            type = lib.types.bool;
            default = false;
          };
          browseable = lib.mkOption {
            description = "Whether the share is browseable.";
            type = lib.types.bool;
            default = true;
          };
          comment = lib.mkOption {
            description = "An optional comment.";
            type = lib.types.str;
            default = name;
          };
          read-only = lib.mkOption {
            description = "Whether the share should be read only.";
            type = lib.types.bool;
            default = false;
          };
          only-owner-editable = lib.mkOption {
            description = "Whether the share is only writable by the system owner (plusultra.user.name).";
            type = lib.types.bool;
            default = false;
          };

          extra-config = lib.mkOption {
            description = "Extra configuration options for the share.";
            type = lib.types.attrs;
            default = { };
          };
        };
      }
    );
in
{
  options.plusultra.services.samba = {
    enable = lib.mkEnableOption "Samba";

    workgroup = lib.mkOption {
      description = "The workgroup name.";
      type = lib.types.str;
      default = "WORKGROUP";
    };

    browseable = lib.mkOption {
      description = "Whether the server is browseable.";
      type = lib.types.bool;
      default = true;
    };

    shares = lib.mkOption {
      description = "The shares to serve.";
      type = lib.types.attrsOf shares-submodule;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
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

      settings = {
        global = {
          browseable = bool-to-yes-no cfg.browseable;
        };
      } // (
        builtins.mapAttrs
          (
            name: value:
              {
                inherit (value) path comment;

                public = bool-to-yes-no value.public;
                browseable = bool-to-yes-no value.browseable;
                "read only" = bool-to-yes-no value.read-only;
              }
              // (lib.optionalAttrs value.only-owner-editable {
                "write list" = config.plusultra.user.name;
                "read list" = "guest, nobody";
                "create mask" = "0755";
              })
              // value.extra-config
          )
          cfg.shares
      );

    };
  };
}
