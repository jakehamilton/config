{
  lib,
  config,
  pkgs,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.vault-agent;

  # nixos-vault-service places generated files here:
  # https://github.com/DeterminateSystems/nixos-vault-service/blob/45e65627dff5dc4bb40d0f2595916f37e78959c1/module/helpers.nix#L4
  secret-files-root = "/tmp/detsys-vault";
  environment-files-root = "/run/keys/environment";

  create-environment-files-submodule =
    service-name:
    types.submodule (
      { name, ... }:
      {
        options = {
          text = mkOpt (types.nullOr types.str) null "An inline template for Vault to template.";
          source =
            mkOpt (types.nullOr types.path) null
              "The file with environment variables for Vault to template.";
          path = mkOption {
            readOnly = true;
            type = types.str;
            description = "The path to the environment file.";
            default = "${environment-files-root}/${service-name}/${name}.EnvFile";
            defaultText = "${environment-files-root}/<service-name>/<template-name>.EnvFile";
          };
        };
      }
    );

  secret-files-submodule = types.submodule (
    { name, ... }:
    {
      options = {
        text = mkOpt (types.nullOr types.str) null "An inline template for Vault to template.";
        source = mkOpt (types.nullOr types.path) null "The file for Vault to template.";
        permissions = mkOpt types.str "0400" "The octal mode of this file.";
        change-action = mkOpt (types.nullOr (
          types.enum [
            "restart"
            "stop"
            "none"
          ]
        )) null "The action to take when secrets change.";
        path = mkOption {
          readOnly = true;
          type = types.str;
          description = "The path to the secret file.";
          default = "${secret-files-root}/${name}";
        };
      };
    }
  );

  services-submodule = types.submodule (
    { name, config, ... }:
    {
      options = {
        enable = mkBoolOpt true "Whether to enable Vault Agent for this service.";
        settings = mkOpt types.attrs { } "Vault Agent configuration.";
        secrets = {
          environment = {
            force =
              mkOpt types.bool false
                "Whether or not to force the use of Vault Agent's environment files.";
            change-action = mkOpt (types.enum [
              "restart"
              "stop"
              "none"
            ]) "restart" "The action to take when secrets change.";
            templates = mkOpt (types.attrsOf (
              create-environment-files-submodule name
            )) { } "Environment variable files for Vault to template.";
            template = mkOpt (types.nullOr (
              types.either types.path types.str
            )) null "An environment variable template.";
            paths = mkOption {
              readOnly = true;
              type = types.listOf types.str;
              description = "Paths to all of the environment files";
              default =
                if config.secrets.environment.template != null then
                  [ "${environment-files-root}/${name}/EnvFile" ]
                else
                  (mapAttrsToList (template-name: value: value.path) config.secrets.environment.templates);
            };
          };

          file = {
            change-action = mkOpt (types.enum [
              "restart"
              "stop"
              "none"
            ]) "restart" "The action to take when secrets change.";
            files = mkOption {
              description = "Secret files to template.";
              default = { };
              type = types.attrsOf secret-files-submodule;
            };
          };
        };
      };
    }
  );
in
{
  # imports = [
  #   inputs.vault-service.nixosModules.nixos-vault-service
  # ];

  options.${namespace}.services.vault-agent = {
    enable = mkEnableOption "Vault Agent";

    settings = mkOpt types.attrs { } "Default Vault Agent configuration.";

    services = mkOption {
      description = "Services to install Vault Agent into.";
      default = { };
      type = types.attrsOf services-submodule;
    };
  };

  config = mkIf cfg.enable {
    assertions = flatten (
      mapAttrsToList (
        service-name: service:
        (mapAttrsToList (template-name: template: {
          assertion =
            (template.source != null && template.text == null)
            || (template.source == null && template.text != null);
          message = "plusultra.services.vault-agent.services.${service-name}.secrets.environment.templates.${template-name} must set either `source` or `text`.";
        }) service.secrets.environment.templates)
        ++ (mapAttrsToList (file-name: file: {
          assertion =
            (file.source != null && file.text == null) || (file.source == null && file.text != null);
          message = "plusultra.services.vault-agent.services.${service-name}.secrets.file.files.${file-name} must set either `source` or `text`.";
        }) service.secrets.file.files)
      ) cfg.services
    );

    systemd.services = mapAttrs (
      service-name: value:
      mkIf value.secrets.environment.force {
        serviceConfig.EnvironmentFile = mkForce value.secrets.environment.paths;
      }
    ) cfg.services;

    detsys.vaultAgent = {
      defaultAgentConfig = cfg.settings;

      systemd.services = mapAttrs (service-name: value: {
        inherit (value) enable;

        agentConfig = value.settings;

        environment = {
          changeAction = value.secrets.environment.change-action;

          templateFiles = mapAttrs (template-name: value: {
            file =
              if value.source != null then
                value.source
              else
                pkgs.writeText "${service-name}-${template-name}-env-template" value.text;
          }) value.secrets.environment.templates;

          template =
            if
              (builtins.isPath value.secrets.environment.template)
              || (builtins.isNull value.secrets.environment.template)
            then
              value.secrets.environment.template
            else
              pkgs.writeText "${service-name}-env-template" value.secrets.environment.template;
        };

        secretFiles = {
          defaultChangeAction = value.secrets.file.change-action;

          files = mapAttrs (file-name: value: {
            changeAction = value.change-action;
            template = value.text;
            templateFile = value.source;
            perms = value.permissions;
          }) value.secrets.file.files;
        };
      }) cfg.services;
    };
  };
}
