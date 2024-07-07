{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.attic;

  toml-format = pkgs.formats.toml { };

  raw-server-toml = toml-format.generate "server.toml" cfg.settings;

  server-toml = pkgs.runCommand "checked-server.toml" { config = raw-server-toml; } ''
    cat $config

    export ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="dGVzdCBzZWNyZXQ="
    export ATTIC_SERVER_DATABASE_URL="sqlite://:memory:"

    ${cfg.package}/bin/atticd --mode check-config -f "$config"

    cat < $config > $out
  '';

  is-local-postgres =
    let
      url = cfg.settings.database.url or "";
      local-db-strings = [
        "localhost"
        "127.0.0.1"
        "/run/postgresql"
      ];
      is-local-db-url = any (flip hasInfix url) local-db-strings;
    in
    config.services.postgresql.enable && hasPrefix "postgresql://" url && is-local-db-url;
in
{
  options.${namespace}.services.attic = {
    enable = mkEnableOption "Attic";

    package = mkOpt types.package pkgs.attic-server "The attic-server package to use.";

    credentials =
      mkOpt (types.nullOr types.path) null
        "The path to an optional EnvironmentFile for the atticd service to use.";

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

      groups = optionalAttrs (cfg.group == "atticd") { atticd = { }; };
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
      after =
        [ "network.target" ]
        ++ optionals is-local-postgres [
          "postgresql.service"
          "nss-lookup.target"
        ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/atticd -f ${server-toml}";
        StateDirectory = "atticd";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
      } // optionalAttrs (cfg.credentials != null) { EnvironmentFile = mkDefault cfg.credentials; };
    };
  };
}
