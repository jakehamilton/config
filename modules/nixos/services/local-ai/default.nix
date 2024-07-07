{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.local-ai;

  inherit (lib)
    mkEnableOption
    mkIf
    types
    optionalAttrs
    optionalString
    ;
  inherit (lib.${namespace}) mkOpt;

  address = "${cfg.host}:${toString cfg.port}";

  prepare-models-directory =
    if cfg.models == null then
      ''
        if [[ -L '${cfg.stateDir}/models' ]]; then
          rm -rf '${cfg.stateDir}/models'
        fi

        mkdir -p '${cfg.stateDir}/models'
      ''
    else
      ''
        if [[ -d '${cfg.stateDir}/models' ]]; then
          rm -rf '${cfg.stateDir}/models'
        fi

        ln -s '${cfg.models}' '${cfg.stateDir}/models'
      '';
in
{
  options.${namespace}.services.local-ai = {
    enable = mkEnableOption "LocalAI";

    package = mkOpt types.package pkgs.plusultra.local-ai "The package to use.";

    user = mkOpt types.str "localai" "User under which LocalAI is ran.";

    group = mkOpt types.str "localai" "Group under which LocalAI is ran.";

    stateDir =
      mkOpt types.path "/var/lib/local-ai"
        "The state directory where keys and data are stored.";

    # The models directory should contain models as well as templates and configuration.
    # For example, to fetch a model:
    # wget https://huggingface.co/TheBloke/Luna-AI-Llama2-Uncensored-GGUF/resolve/main/luna-ai-llama2-uncensored.Q4_0.gguf -O models/luna-ai-llama2
    #
    # And an example template to use with the above model as luna-ai-llama2.tmpl:
    #    The prompt below is a question to answer, a task to complete, or a conversation to respond to; decide which and write an appropriate response.
    #    ### Prompt:
    #    {{.Input}}
    #    ### Response:
    models = mkOpt (types.nullOr types.path) null "A directory of models and templates to use.";

    host = mkOpt types.str "" "The host to bind to.";

    port = mkOpt types.port 8080 "The port to bind to.";

    cors = {
      enable = mkOpt types.bool false "Allow cross origin requests.";
      allow = mkOpt (types.listOf types.str) [ "*" ] "The origin to allow.";
    };
  };

  config = mkIf cfg.enable {
    users = {
      users = optionalAttrs (cfg.user == "localai") {
        localai = {
          group = cfg.group;
          home = cfg.stateDir;
          isSystemUser = true;
        };
      };

      groups = optionalAttrs (cfg.group == "localai") { localai = { }; };
    };

    systemd.tmpfiles.rules = [ "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} -" ];

    systemd.services.local-ai = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment =
        {
          ADDRESS = address;
        }
        // optionalAttrs cfg.cors.enable {
          CORS = if cfg.cors.enable then "true" else "false";
          CORS_ALLOW_ORIGINS = builtins.toString cfg.cors.allow;
        };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        Restart = "always";
        RestartSec = 20;
        ExecStart = "${cfg.package}/bin/local-ai --address '${address}'";
        PrivateTmp = true;
      };

      preStart = ''
        ${prepare-models-directory}
      '';
    };
  };
}
