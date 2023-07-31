{ lib, config, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.plusultra.services.attic;

  toml-format = pkgs.formats.toml { };

  raw-server-toml = toml-format.generate "server.toml" cfg.settings;

  server-toml = pkgs.runCommand "checked-server.toml" { config = raw-server-toml; } ''
    cat $config

    export ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="dGVzdCBzZWNyZXQ="
    export ATTIC_SERVER_DATABASE_URL="sqlite://:memory:"

    ${cfg.package}/bin/atticd --mode check-config -f "$config"

    cat < $config > $out
  '';

  atticadm-shim = pkgs.writeShellScript "atticadm" ''
    if [ -n "$ATTICADM_PWD" ]; then
      cd "$ATTICADM_PWD"
      if [ "$?" != "0" ]; then
        >&2 echo "Warning: Failed to change directory to $ATTICADM_PWD"
      fi
    fi

    exec ${cfg.package}/bin/atticadm -f ${server-toml} "$@"
  '';

  atticadm-systemd-wrapper = pkgs.writeShellScript "atticd-atticadm" ''
    exec systemd-run \
      --quiet \
      --pty \
      --same-dir \
      --wait \
      --collect \
      --service-type=exec \
      --property=DynamicUser=yes \
      --property=User=atticd \
      --property=Environment=ATTICADM_PWD=$(pwd) \
      --property=JoinsNamespaceOf=atticd.service \
      ${builtins.map (path: "--property=EnvironmentFile=${path}") config.plusultra.services.vault-agent.services.atticd.secrets.environment.paths} \
      --working-directory / \
      -- \
      ${atticadm-shim} "$@"
  '';

  is-local-postgres =
    let
      url = cfg.settings.database.url or "";
      local-db-strings = [ "localhost" "127.0.0.1" "/run/postgresql" ];
      is-local-db-url = any (flip hasInfix url) local-db-strings;
    in
    config.services.postgresql.enable
    && hasPrefix "postgresql://" url
    && is-local-db-url;
in
{
  options.plusultra.services.attic = {
    enable = mkEnableOption "Attic";

    package = mkOpt types.package pkgs.attic-server "The attic-server package to use.";

    credentials = mkOpt (types.nullOr types.path) null "The path to an optional EnvironmentFile for the atticd service to use.";

    user = mkOpt types.str "atticd" "The user under which attic runs.";
    group = mkOpt types.str "atticd" "The group under which attic runs.";

    settings = mkOpt toml-format.type { } "Settings for the atticd config file.";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !isStorePath cfg.credentials;
        message = "plusultra.services.attic.credentials CANNOT be in the Nix Store.";
      }
    ];

    users = {
      users = optionalAttrs (cfg.user == "atticd") {
        atticd = {
          group = cfg.group;
          isSystemUser = true;
        };
      };

      groups = optionalAttrs (cfg.group == "atticd") {
        atticd = { };
      };
    };

    plusultra = {
      tools.attic = enabled;

      services.attic.settings = {
        database.url = mkDefault "sqlite:///var/lib/atticd/server.db?mode=rwc";

        storage = mkDefault {
          type = "local";
          path = "/var/lib/atticd/storage";
        };
      };
    };

    systemd.services.atticd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]
        ++ optionals is-local-postgres [ "postgresql.service" "nss-lookup.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/atticd -f ${server-toml}";
        StateDirectory = "atticd";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
      } // optionalAttrs (cfg.credentials != null) {
        EnvironmentFile = mkDefault cfg.credentials;
      };
    };
  };
}
